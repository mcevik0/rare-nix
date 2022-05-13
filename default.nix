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

## By default, the installers are built for all supported platforms
## and kernels. This can be restricted to the given list of platforms
## and kernel identifiers
, installerPlatforms ? []
, installerKernels ? []

## Optional dynamic override of the source of freerouter. This set
## should contain the attributes "version" and "src" to override
## overlay/freerouter/repo.nix.
, freerouterSrc ? {}
}:

let
  freerouterOverlay = self: super:
    {
      freerouter-jar = super.freerouter-jar.overrideAttrs (oldAttrs:
        freerouterSrc
      );
    };
  pkgs = import (fetchTarball {
    url = https://github.com/alexandergall/bf-sde-nixpkgs/archive/3f480a.tar.gz;
    sha256 = "018kcyn444kb6radcrlcfi6hgfqmv305cp14yl6sfdzlwh72zcbz";
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

  bf-sde = pkgs.bf-sde.v9_7_1;
  support = bf-sde.support;

  p4Profiles = import rare/p4-profiles.nix {
    inherit (pkgs) lib;
    inherit bf-sde;
  };

  sliceCommon = {
    versionFile = pkgs.writeTextDir "version" "${version}:${gitTag}\n";
    release-manager = import ./release-manager {
      inherit support version nixProfile p4Profiles;
      defaultProfile = "PE";
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
  platforms = select installerPlatforms supportedPlatforms;
  kernelModules =
    with builtins;
    let
      allModules = bf-sde.pkgs.kernel-modules;
      names = select installerKernels (attrNames allModules);
    in
    pkgs.lib.filterAttrs (n: v: elem n names) allModules;
  release = support.mkRelease slice kernelModules platforms;
  component = "RARE";
  releaseClosure = support.mkReleaseClosure release component;
  onieInstaller = (support.mkOnieInstaller {
    inherit version nixProfile component binaryCaches;
    platforms = builtins.filter (platform: platform != "model") platforms;
    ## The kernel used here must match that from the profile
    partialSlice = slice bf-sde.pkgs.kernel-modules.Debian11_0;
    bootstrapProfile = ./onie/profile;
    fileTree = ./onie/files;
    NOS = "${component}-OS";
    users = {
      rare = {
        useraddArgs = "-s /bin/bash";
        password = "rare";
        sshPublicKey = pkgs.lib.removeSuffix "\n" (builtins.readFile ./onie/rare_id.pub);
        passwordlessSudo = false;
      };
    };
  }).override { memSize = 7*1024; };
  standaloneInstaller = support.mkStandaloneInstaller {
    inherit release version gitTag nixProfile component;
  };
in {
  inherit release releaseClosure onieInstaller standaloneInstaller;
  ## For the "install" make target
  inherit (sliceCommon) release-manager;

  ## Final installation on the target system with
  ##   nix-env -f . -p <some-profile-name> -r -i -A install --argstr kernelRelease $(uname -r) --argstr platform <platform>
  install =
    assert kernelRelease != null && platform != null;
    assert pkgs.lib.assertMsg (builtins.elem platform supportedPlatforms) "Unsupported platform: ${platform}";
    slice (bf-sde.modulesForKernel kernelRelease) platform;
}
