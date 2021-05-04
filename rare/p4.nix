{ bf-sde, profile, buildFlags, lib, fetchgit }:

let
  repo = import ./repo.nix { inherit fetchgit; };
  profileStr = sep:
    lib.optionalString (profile != null) "${sep}${profile}";
in bf-sde.buildP4Program {
  inherit (repo) version src;
  pname = "RARE${profileStr "-"}";
  p4Name = "bf_router";
  path = "p4src";
  execName = "bf_router${profileStr "_"}";

  ## XXXX: make platform configurable
  buildFlags = [ "-I${repo.src}/p4src" "-D_WEDGE100BF32X_" ] ++ buildFlags;
  requiredKernelModule = "bf_kpkt";
  patches = [ ./profiles.patch ];
}
