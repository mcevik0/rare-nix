{ bf-sde, callPackage, platform }:

let
  platforms = import ./platforms.nix;
  profiles = {
    bier = [ "-DPROFILE_BIER" ];
    gre = [ "-DPROFILE_GRE" ];
    l2tp = [ "-DPROFILE_L2TP" ];
    mldp = [ "-DPROFILE_MLDP" ];
    mpls = [ "-DPROFILE_MPLS" ];
    pppoe = [ "-DPROFILE_PPPOE" ];
    rawip = [ "-DPROFILE_RAWIP" ];
  };
  buildP4 = profile: buildFlags:
    callPackage ./p4.nix {
    inherit bf-sde profile platform;
    buildFlags = buildFlags ++ platforms.${platform};
  };
in builtins.mapAttrs buildP4 profiles
