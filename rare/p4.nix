{ bf-sde, profile, platform, buildFlags, fetchgit }:

let
  repo = import ./repo.nix { inherit fetchgit; };
in bf-sde.buildP4Program {
  inherit (repo) version src;
  inherit platform;
  pname = "RARE-${profile}-${platform}";
  p4Name = "bf_router";
  path = "p4src";
  execName = "bf_router_${profile}";

  buildFlags = [ "-I${repo.src}/p4src -I${repo.src}/profiles/${bf-sde.version}/${bf-sde.platforms.${platform}.target}" ]
               ++ buildFlags;
  requiredKernelModule = "bf_kpkt";
}
