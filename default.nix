{
## When called from Hydra via release.nix or from "release-manager
## --install-git", we get the result of "git describe" passed in as
## gitTag.
  gitTag ? "WIP"
## kernelRelease and platform are required when building the "install"
## attribute
, kernelRelease ? null
, platform ? null

## A list of binary caches to be included in nix.conf of the image
## created by the ONIE Installer. It is not required for running the
## application bundled with the installer. However, it *is* required
## to install different versions of the application after the initial
## installation, e.g. with the release-manager.  In that case, the
## list must include a cache that contains the packages that have been
## pre-built by a Hydra CI instance (either only the runtime versions
## or the full version if the "sde-env" development shell needs to be
## available). The intended use is to specify the list in a Hydra
## declarative jobset (JSON "spec" file) when building the packages
## via release.nix.  The list must contain sets of the form
##   {
##     url = ...;
##     key = ...;
##   }
## where "url" and "key" must be strings in the format required by the
## "trusted-substituters" and "trusted-public-keys" Nix options
## according to nix.conf(5)
, binaryCaches ? []

## By default, the release is built for all platforms listed in
## rare/platforms.nix. A subset of that list can be selected to
## restrict the platforms included in the release.
, releasePlatforms ? []

## The release can include kernel modules for all kernels listed in
## rare/kernels.nix (which must be a subset of the kernels supported
## by the selected SDE version). A subset of that list can be selecetd
## to restrict the kernel versions included in the release.
, releaseKernels ? []

## Optional dynamic override of the source of freerouter. This set
## should contain the attributes "version" and "src" to override
## overlay/freerouter/repo.nix.
, freerouterSrc ? {}

## Whether to activate RARE in the ONIE installer
, activate ? true

## Whether to include the full SDE development environment in the ONIE
## installer
, withSdeEnv ? false
}:

let
  freerouterOverlay = self: super:
    {
      freerouter-jar = super.freerouter-jar.overrideAttrs (oldAttrs:
        freerouterSrc
      );
    };
  pkgs = import (fetchTarball {
    url = https://github.com/alexandergall/bf-sde-nixpkgs/archive/91268e.tar.gz;
    sha256 = "178pqpzzza8bxawv3drwyr77pbq442p5k4xrpsg4m9q53vkrmn25";
  }) {
    overlays = import ./overlay ++ [ freerouterOverlay ];
  };

  ## Release workflow when the final change has been committed (that
  ## commit should also include the final version of the release
  ## notes):
  ##   * tag commit with release-<version>
  ##   * create a branch <version>
  ##   * Create a new commit on master
  ##      * Add Hydra CI job for <version> branch to spec.json
  ##      * Add Hydra CI job for <version> branch to spec-ONIE-SWITCH.json
  ##      * Bump version <version+1>
  ##      * Add release-notes/release-<version+1>
  version = "2";
  nixProfile = "/nix/var/nix/profiles/RARE";

  bf-sde = pkgs.bf-sde.v9_13_3;
  support = bf-sde.support;

  p4Profiles = import rare/p4-profiles.nix {
    inherit pkgs bf-sde;
  };

  sliceCommon = {
    versionFile = pkgs.writeTextDir "version" "${version}:${gitTag}\n";
    release-manager = import ./release-manager {
      inherit support version nixProfile p4Profiles;
      defaultProfile = "PE";
      bash = pkgs.bash;
    };
    inherit (pkgs) freerouter freerouter-native;

    ## nix-env does not handle multi-output derivations correctly. We
    ## work around this by wrapping those derivations in an
    ## environment.
    auxEnv = pkgs.buildEnv {
      name = "aux-env";
      paths = [ bf-sde.pkgs.bf-utils ];
    };
  };

  ## A slice is the subset of a release that only contains the modules
  ## and wrappers for a single kernel and a particular platform.  At
  ## install time, the installer selects the slice that matches the
  ## system's kernel and platform.
  slice = kernelModules: platform:
    let
      sliceFile = pkgs.writeTextDir "slice"
        "${kernelModules.kernelID}:${kernelModules.kernelRelease}:${platform}\n";
      bfForwarder = import rare/forwarder { inherit bf-sde platform pkgs; };
      programs = import ./rare {
        inherit bf-sde platform p4Profiles pkgs;
      };
      moduleWrappers = builtins.mapAttrs
        (_: program: program.moduleWrapper' kernelModules) programs;
      scripts = pkgs.callPackage ./scripts {
        inherit moduleWrappers bfForwarder p4Profiles nixProfile;
        runtimeEnv = bf-sde.runtimeEnvNoBsp;
      };
      freeRtrHwConfig = pkgs.callPackage ./release-manager/rtr-hw.nix {
        inherit bf-sde platform scripts;
        inherit (pkgs) freerouter-native;
        inherit (sliceCommon) release-manager;
      };
    in (import ./services {
      inherit pkgs bf-sde platform scripts;
      inherit (sliceCommon) release-manager;
    }) // sliceCommon // moduleWrappers // {
      inherit sliceFile scripts freeRtrHwConfig kernelModules;
    };

  select = l1: l2:
    with builtins;
    with pkgs.lib;
    if length l1 == 0 then
      l2
    else
      assert assertMsg (sort lessThan (intersectLists l1 l2) == sort lessThan l1)
        "\"${toString l1}\" must be a subset of \"${toString l2}\"";
      l1;

  ## A release is the union of the slices for all supported kernels
  ## and platforms. The slices have a fairly large overlap of
  ## identical packages, which creates a rather big Hydra job set, but
  ## that's just a cosmetic issue.
  supportedPlatforms = builtins.attrNames (import ./rare/platforms.nix);
  platforms = select releasePlatforms supportedPlatforms;
  kernelModules =
    with builtins;
    let
      allModules = bf-sde.pkgs.kernel-modules;
      selectedKernels = select releaseKernels (import rare/kernels.nix);
    in
    pkgs.lib.filterAttrs (n: v: elem n selectedKernels) allModules;
  release = support.mkRelease slice kernelModules platforms;
  component = "RARE";
  releaseClosure = support.mkReleaseClosure release component;
  onieInstaller = (support.mkOnieInstaller {
    inherit version nixProfile component binaryCaches platforms slice activate withSdeEnv;
    bootstrapProfile = ./onie/profile;
    fileTree = ./onie/files;
    NOS = "${component}-OS";
    users = {
      fabric = {
        useraddArgs = "-s /bin/bash";
        password = "<Fetch password from FABRIC_1Password_Device-Logins/Deployment_P4-Tofino-SSH-Key-FABRIC_ID>";
        sshPublicKey = pkgs.lib.removeSuffix "\n" (builtins.readFile ./onie/fabric_id.pub);
        passwordlessSudo = true;
      };
      rare = {
        useraddArgs = "-s /bin/bash";
        password = "<Fetch password from FABRIC_1Password_Device-Logins/Deployment_P4-Tofino-SSH-Key-RARE_ID>";
        sshPublicKey = pkgs.lib.removeSuffix "\n" (builtins.readFile ./onie/rare_id.pub);
        passwordlessSudo = false;
      };
    };
  }).override { memSize = 10*1024; };
  standaloneInstaller = support.mkStandaloneInstaller {
    inherit release version gitTag nixProfile component;
  };
in {
  inherit release releaseClosure onieInstaller standaloneInstaller;
  ## For the "install" make target
  inherit (sliceCommon) release-manager;

  ## Helper function for the profile optimizier to discover all sets
  ## of distinct P4 compiler flags for a specific profile and P4
  ## target. See comment there for specific usage.
  flagsForProfile = profile: target:
    import ./rare/compiler-flags.nix {
      inherit profile target p4Profiles supportedPlatforms pkgs bf-sde;
    };
  ## Make the SDE used to build RARE available. This is used by the
  ## optimizer in the rare Git repo to compile the profiles with the
  ## exact same environment.
  inherit bf-sde;

  ## Final installation on the target system with
  ##   nix-env -f . -p <some-profile-name> -r -i -A install --argstr kernelRelease $(uname -r) --argstr platform <platform>
  install =
    assert kernelRelease != null && platform != null;
    assert pkgs.lib.assertMsg (builtins.elem platform supportedPlatforms) "Unsupported platform: ${platform}";
    slice (bf-sde.modulesForKernel kernelRelease) platform;
}
