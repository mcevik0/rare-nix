## When called from Hydra via release.nix or from "release-manager
## --install-git", we get the result of "git describe" passed in as
## gitTag.
{ gitTag ? "WIP", kernelRelease ? null, platform ? null }:

let
  pkgs = import (fetchTarball {
    url = https://github.com/alexandergall/bf-sde-nixpkgs/archive/v13.tar.gz;
    sha256 = "0r2syp9zrpwlg9wf36655m29i39p9qylqyr2xk3q8xkcchysj6qf";
  }) {
    overlays = import ./overlay;
  };

  ## Release workflow when the final change has been committed (that
  ## commit should also include the final version of the release
  ## notes):
  ##   * tag commit with release-<version>
  ##   * create a branch <version>
  ##   * Create a new commit on master
  ##      * Add Hydra CI job for <version> branch to spec.json
  ##      * Bump version <version+1>
  ##      * Add release-notes/release-<version+1>
  version = "1eta";
  nixProfile = "/nix/var/nix/profiles/RARE";

  ## Starting with v10, the SDE supports 9.6.0, but only the reference
  ## BSP is available for for that version.  We stick to 9.5.0 to be
  ## able to support the other BSPs.
  bf-sde = pkgs.bf-sde.v9_5_0;
  support = bf-sde.support;

  sliceCommon = {
    versionFile = pkgs.writeTextDir "version" "${version}:${gitTag}\n";
    bfForwarder = import rare/forwarder { inherit bf-sde pkgs; };
    release-manager = import ./release-manager {
      inherit support version nixProfile;
      defaultProfile = "p4lab_1";
    };
    inherit (pkgs) freerouter;

    ## nix-env does not handle multi-output derivations correctly. We
    ## work around this by wrapping those derivations in an
    ## environment.
    auxEnv = pkgs.buildEnv {
      name = "aux-env";
      paths = [ bf-sde.pkgs.bf-utils pkgs.freerouter.native ];
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
      programs = import ./rare {
        inherit bf-sde platform pkgs;
      };
      moduleWrappers = builtins.mapAttrs
        (_: program: program.moduleWrapper' kernelModules) programs;
      scripts = pkgs.callPackage ./scripts {
        inherit moduleWrappers;
        inherit (sliceCommon) bfForwarder;
        runtimeEnv = bf-sde.runtimeEnvNoBsp;
      };
      freeRtrHwConfig = pkgs.callPackage ./release-manager/rtr-hw.nix {
        inherit platform nixProfile;
      };
    in (import ./services { inherit pkgs platform scripts; }) //
       sliceCommon // moduleWrappers // {
         inherit sliceFile scripts freeRtrHwConfig kernelModules;
       };

  ## A release is the union of the slices for all supported kernels
  ## and platforms. The slices have a fairly large overlap of
  ## identical packages, which creates a rather big Hydra job set, but
  ## that's just a cosmetic issue.
  platforms = builtins.attrNames (import ./rare/platforms.nix);
  release = support.mkRelease slice bf-sde.pkgs.kernel-modules platforms;
  component = "RARE";
  releaseClosure = support.mkReleaseClosure release component;
  onieInstaller = (support.mkOnieInstaller {
    inherit version nixProfile platforms component;
    ## The kernel used here must match that from the profile
    partialSlice = slice bf-sde.pkgs.kernel-modules.Debian11_0;
    bootstrapProfile = ./onie/profile;
    fileTree = ./onie/files;
    NOS = "${component}-OS";
    binaryCaches = [ {
      url = "http://p4.cache.nix.net.switch.ch";
      key = "p4.cache.nix.net.switch.ch:cR3VMGz/gdZIdBIaUuh42clnVi5OS1McaiJwFTn5X5g=";
    } ];
    users = {
      rare = {
        useraddArgs = "-s /bin/bash";
        password = "rare";
        sshPublicKey = pkgs.lib.removeSuffix "\n" (builtins.readFile ./onie/rare_id.pub);
        passwordlessSudo = false;
      };
    };
  }).override { memSize = 6*1024; };
  standaloneInstaller = support.mkStandaloneInstaller {
    inherit release version gitTag nixProfile component;
  };
in {
  inherit release releaseClosure onieInstaller standaloneInstaller;

  ## Final installation on the target system with
  ##   nix-env -f . -p <some-profile-name> -r -i -A install --argstr kernelRelease $(uname -r) --argstr platform <platform>
  install =
    assert kernelRelease != null && platform != null;
    assert pkgs.lib.assertMsg (builtins.elem platform platforms) "Unsupported platform: ${platform}";
    slice (bf-sde.modulesForKernel kernelRelease) platform;
}
