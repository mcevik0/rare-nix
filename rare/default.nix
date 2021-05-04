{ bf-sde, callPackage }:

let
  programs = {
    bier = {
      buildFlags = [ "-DPROFILE_BIER" ];
    };
    gre = {
      buildFlags = [ "-DPROFILE_GRE" ];
    };
    l2tp = {
      buildFlags = [ "-DPROFILE_L2TP" ];
    };
    mldp = {
      buildFlags = [ "-DPROFILE_MLDP" ];
    };
    mpls = {
      buildFlags = [ "-DPROFILE_MPLS" ];
    };
    pppoe = {
      buildFlags = [ "-DPROFILE_PPPOE" ];
    };
    rawip = {
      buildFlags = [ "-DPROFILE_RAWIP" ];
    };
  };
  buildP4 = profile: attrs:
    callPackage ./p4.nix {
      inherit bf-sde profile;
      inherit (attrs) buildFlags;
    };
in builtins.mapAttrs buildP4 programs
