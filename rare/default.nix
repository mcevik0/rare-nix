{ bf-sde, platform, p4Profiles, pkgs }:

let
  repo = import ./repo.nix { inherit (pkgs) fetchgit; };
  target = bf-sde.platforms.${platform}.target;
  buildP4 = profile: flags:
    bf-sde.buildP4Program {
      inherit (repo) version src;
      inherit platform;
      pname = "RARE-${profile}-${platform}";
      p4Name = "bf_router";
      path = "p4src";
      execName = "bf_router_${profile}";
      buildFlags = p4Profiles.${profile} { inherit platform; }
                   ++ [ "-I${repo.src}/p4src -I${repo.src}/profiles/${bf-sde.version}/${target}" ];
      requiredKernelModule = "bf_kpkt";
    };
in builtins.mapAttrs buildP4 p4Profiles
