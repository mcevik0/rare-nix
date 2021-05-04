## When called from Hydra via release.nix or from "release-manager
## --install-git", we get the result of "git describe" passed in as
## gitTag.
{ gitTag ? "WIP", kernelRelease ? null }:

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
  version = "1";
  versionFile = pkgs.writeTextDir "version" "${version}:${gitTag}\n";
  nixProfile = "/nix/var/nix/profiles/RARE";

  ## Build the main components with the latest SDE version
  bf-sde = pkgs.bf-sde.latest;

  fetchBitbucketPrivate = pkgs.callPackage ./fetchbitbucket {};
  sal_modules = pkgs.callPackage ./sal/modules.nix {
    inherit fetchBitbucketPrivate;
  };
  programs = import ./rare {
    inherit bf-sde;
    inherit (pkgs) callPackage;
  };
  bf-forwarder = pkgs.callPackage ./rare/bf-forwarder.nix {
    inherit bf-sde sal_modules;
  };
  services = import ./services { inherit pkgs; };
  release-manager = pkgs.callPackage ./release-manager {
    inherit version nixProfile;
  };
  freerouter = pkgs.freerouter.overrideAttrs (oldAttrs: {
    meta = oldAttrs.meta or {} // {
	  outputsToInstall = [ "out" "native" ];
	};
  });

  ## A slice is the subset of a release that only contains the
  ## modules and wrappers for a single kernel.  At install time on a
  ## particular system, the installer selects the slice that matches
  ## the system's kernel. A slice is identified by the kernelID of the
  ## selected modules package. The kernel release identifier is
  ## included as well to let the release-manager provide more useful
  ## output.
  slice = kernelModules:
    let
      sliceFile = pkgs.writeTextDir "slice"
        "${kernelModules.kernelID}:${kernelModules.kernelRelease}\n";
      moduleWrappers = builtins.mapAttrs
                       (_: program: program.moduleWrapper' kernelModules) programs;
      scripts = pkgs.callPackage ./scripts {
        inherit bf-sde moduleWrappers;
      };
    in moduleWrappers // services // {
      inherit versionFile sliceFile scripts release-manager bf-forwarder
              kernelModules freerouter;
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
  release = builtins.mapAttrs (_: modules: slice modules) bf-sde.pkgs.kernel-modules;

  ## The closure of the release is the list of paths that needs to be
  ## available on a binary cache for pure binary deployments.  To
  ## satisfy restrictions imposed by Intel on the distribution of
  ## parts of the SDE as a runtime system, we set up a post-build hook
  ## on the Hydra CI system to copy these paths to a separate binary
  ## cache which can be made available to third parties. The hook uses
  ## the releaseClosure to find all paths from a single derivation. It
  ## is triggered by the name of that derivation, hence the override.
  releaseClosure = (pkgs.closureInfo {
    rootPaths = builtins.foldl'
                  (final: next: final ++ (builtins.attrValues next)) []
                  (builtins.attrValues release);
  }).overrideAttrs (_: { name = "RARE-release-closure"; });

  mkOnieInstaller = pkgs.callPackage (pkgs.fetchgit {
    url = "https://github.com/alexandergall/onie-debian-nix-installer";
    rev = "be4053";
    sha256 = "1m74hl9f34i5blpb0l6vfq5mzaqjh1nv50nyj1m3x29wyzks2scc";
  }) {};
  onieInstaller = mkOnieInstaller {
    inherit nixProfile version;
    component = "RARE";
    NOS = "RARE-OS";
    ## The kernel selected here must match the kernel provided by the
    ## bootstrap profile.
    rootPaths = builtins.attrValues (slice bf-sde.pkgs.kernel-modules.Debian10_9);
    bootstrapProfile = ./installers/onie/profile;
    binaryCaches = [ {
      url = "http://p4.cache.nix.net.switch.ch";
      key = "p4.cache.nix.net.switch.ch:cR3VMGz/gdZIdBIaUuh42clnVi5OS1McaiJwFTn5X5g=";
    } ];
    fileTree = ./installers/onie/files;
    #activationCmd = "${nixProfile}/bin/release-manager --activate-current";
  };
  releaseInstaller = pkgs.callPackage ./installers/release-installer.nix {
    inherit release version gitTag nixProfile;
  };

in {
  inherit release releaseClosure onieInstaller releaseInstaller;

  ## Final installation on the target system with
  ##   nix-env -f . -p <some-profile-name> -r -i -A install --argstr kernelRelease $(uname -r)
  install =
    if kernelRelease != null then
      slice (bf-sde.modulesForKernel kernelRelease)
    else
      throw "Missing required argument kernelRelease";
}
