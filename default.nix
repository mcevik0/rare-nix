## When called from Hydra via release.nix or from "release-manager
## --install-git", we get the result of "git describe" passed in as
## gitTag.
{ gitTag ? "WIP", kernelRelease ? null, platform ? null }:

let
  pkgs = import (fetchTarball {
    url = https://github.com/alexandergall/bf-sde-nixpkgs/archive/v8.tar.gz;
    sha256 = "04v45yv3wqr00khj67xywxlzkci4x2zs6hg8ks4f8i6bjskgqxgl";
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
  version = "1delta";
  versionFile = pkgs.writeTextDir "version" "${version}:${gitTag}\n";
  nixProfile = "/nix/var/nix/profiles/RARE";

  ## Build the main components with the latest SDE version
  bf-sde = pkgs.bf-sde.latest;

  fetchBitbucketPrivate = pkgs.callPackage ./fetchbitbucket {};
  sal_modules = pkgs.callPackage ./sal/modules.nix {
    inherit fetchBitbucketPrivate;
  };
  sliceCommon = (import ./services { inherit pkgs; }) // {
    inherit versionFile;
    bf-forwarder = pkgs.callPackage ./rare/bf-forwarder.nix {
      inherit bf-sde sal_modules;
    };
    release-manager = pkgs.callPackage ./release-manager {
      inherit version nixProfile;
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
        inherit bf-sde platform;
        inherit (pkgs) callPackage;
      };
      moduleWrappers = builtins.mapAttrs
        (_: program: program.moduleWrapper' kernelModules) programs;
      scripts = pkgs.callPackage ./scripts {
        inherit moduleWrappers;
        runtimeEnv = bf-sde.runtimeEnvNoBsp;
      };
      freeRtrHwConfig = pkgs.callPackage ./release-manager/rtr-hw.nix {
        inherit platform nixProfile;
      };
    in sliceCommon // moduleWrappers // {
      inherit sliceFile scripts freeRtrHwConfig kernelModules;
    };

  ## A release is the union of the slices for all supported kernels
  ## and platforms. The slices have a fairly large overlap of
  ## identical packages, which creates a rather big Hydra job set, but
  ## that's just a cosmetic issue.
  platforms = builtins.attrNames (import ./rare/platforms.nix);
  namesFromAttrs = attrs:
    attrs.platform + "_" + attrs.kernelModules.kernelID;
  release = builtins.foldl' (final: next:
    final // {
      ${namesFromAttrs next} = slice next.kernelModules next.platform;
    })
    {}
    (pkgs.lib.crossLists (platform: kernelModules: { inherit platform kernelModules; }) [
      platforms
      (builtins.attrValues bf-sde.pkgs.kernel-modules)
    ]);

  ## The closure of the release is the list of paths that needs to be
  ## available on a binary cache for pure binary deployments.  To
  ## satisfy restrictions imposed by Intel on the distribution of
  ## parts of the SDE as a runtime system, we set up a post-build hook
  ## on the Hydra CI system to copy these paths to a separate binary
  ## cache which can be made available to third parties. The hook uses
  ## the releaseClosure to find all paths from a single derivation. It
  ## is triggered by the name of that derivation, hence the override.
  releaseClosure = (pkgs.closureInfo {
    rootPaths = with pkgs.lib; collect (set: isDerivation set) release;
  }).overrideAttrs (_: { name = "RARE-release-closure"; });

  onieInstaller = import installers/onie {
    ## The ONIE installer uses a specific kernel which is determined
    ## at the time the mk-profile.sh utility was run to produce a
    ## snapshot of a Debian system with debootsrap. That particular
    ## kernel must be one of the kernels supported by
    ## bf-sde-nixpkgs. This partial evaluation of the slice selects
    ## that kernel.
    slice = slice bf-sde.pkgs.kernel-modules.Debian10_9;
    inherit pkgs version nixProfile platforms;
  };
  standaloneInstaller = pkgs.callPackage ./installers/standalone {
    inherit release version gitTag nixProfile;
  };

in {
  inherit release releaseClosure onieInstaller standaloneInstaller;

  ## Final installation on the target system with
  ##   nix-env -f . -p <some-profile-name> -r -i -A install --argstr kernelRelease $(uname -r) --argstr platform <platform>
  install =
    assert kernelRelease != null && platform != null;
    slice (bf-sde.modulesForKernel kernelRelease) platform;
}
