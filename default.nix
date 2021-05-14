## When called from Hydra via release.nix or from "release-manager
## --install-git", we get the result of "git describe" passed in as
## gitTag.
{ gitTag ? "WIP", kernelRelease ? null, platform ? null }:

let
  pkgs = import (fetchTarball {
    url = https://github.com/alexandergall/bf-sde-nixpkgs/archive/v7.tar.gz;
    sha256 = "1g5jw4pi3sqi8lkdjjp4lix74sdc57v7a4ff5ymakyq4d1npsm13";
  }) {
    overlays = import ./overlay;
  };

  ## Release wokflow:
  ##   * tag commit with release-<version>
  ##   * create a branch <version>
  ##   * Add Hydra CI job for <version> branch to spec.json
  ##   * Bump version <version+1>
  ##   * Add release-notes/release-<version+1>
  version = "1beta";
  versionFile = pkgs.writeTextDir "version" "${version}:${gitTag}\n";
  nixProfile = "/nix/var/nix/profiles/RARE";

  ## Build the main components with the latest SDE version
  bf-sde = pkgs.bf-sde.latest;

  fetchBitbucketPrivate = pkgs.callPackage ./fetchbitbucket {};
  sal_modules = pkgs.callPackage ./sal/modules.nix {
    inherit fetchBitbucketPrivate;
  };
  bf-forwarder = pkgs.callPackage ./rare/bf-forwarder.nix {
    inherit bf-sde sal_modules;
    inherit (bf-sde.pkgs) runtimeEnv;
  };
  services = import ./services { inherit pkgs; };
  release-manager = pkgs.callPackage ./release-manager {
    inherit version nixProfile;
  };

  ## A slice is the subset of a release that only contains the modules
  ## and wrappers for a single kernel and a particular platform..  At
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
        inherit (bf-sde.pkgs) runtimeEnv;
      };
      freeRtrHwConfig = pkgs.callPackage ./release-manager/rtr-hw.nix {
        inherit platform nixProfile;
      };
    in moduleWrappers // services // rec {
      inherit versionFile sliceFile scripts release-manager bf-forwarder
        kernelModules freeRtrHwConfig;
      inherit (pkgs) freerouter;
      freerouter-native = freerouter.native;

      ## We want to have bfshell in the profile's bin directory. To
      ## achieve that, it should be enough to inherit bf-utils here.
      ## However, bf-utils is a multi-output package and nix-env
      ## unconditonally realizes all outputs when it should just use
      ## meta.outputsToInstall. In this case, the second output is
      ## "dev", which requires the full SDE to be available. This will
      ## fail in a runtime-only binary deployment.  We work around this
      ## by wrapping bf-utils in an environment.
      bf-utils-env = pkgs.buildEnv {
        name = "bf-utils-env";
        paths = [ bf-sde.pkgs.bf-utils ];
      };
    };

  ## A release is the union of the slices for all supported kernels
  ## and platforms.
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
  ##   nix-env -f . -p <some-profile-name> -r -i -A install --argstr kernelRelease $(uname -r) --argstr platform <platform
  install =
    assert kernelRelease != null && platform != null;
    slice (bf-sde.modulesForKernel kernelRelease) platform;
}
