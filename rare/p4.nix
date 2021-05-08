{ bf-sde, profile, platform, buildFlags, lib, fetchgit }:

let
  repo = import ./repo.nix { inherit fetchgit; };
  profileStr = sep:
    lib.optionalString (profile != null) "${sep}${profile}";
in bf-sde.buildP4Program {
  inherit (repo) version src;
  pname = "RARE-${profile}-${platform}";
  p4Name = "bf_router";
  path = "p4src";
  execName = "bf_router_${profile}";

  buildFlags = [ "-I${repo.src}/p4src" ] ++ buildFlags;
  requiredKernelModule = "bf_kpkt";
  patches = [ ./profiles.patch ];
}
