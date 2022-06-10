{ lib, bf-sde }:

## P4 profiles to include in the release.  The attribute name defines
## the name of the profile as it appears in /etc/freertr/p4-profile on
## a running system.  Each profile can have two attributes
##
## <profile> = {
##   buildFlags = [ ... ];
##   bffwdFlags = [ ... ];
## }
##
## The buildFlags attribute must exist and specify a list of flags to
## use when compiling bf_router.p4.  The bffwdFlags attribute is
## optional.  If it is omitted, bf_forwarder.py is started directly
## with standard arguments.  If provided, it must be a list of valid
## arguments to be used for that specific profile, e.g.
##
##  some_profile = {
##    buildFlags = [];
##    bffwdFlags = [ "--some-flag <some-value>" ];
##  }
##
let
  profiles = [
    "BNG"
    "BRAS"
    "CERN_FLOWLAB"
    "CGNAT"
    "CLEANER"
    "CPE"
    "FW"
    "GEANT_TESTBED"
    "GRE"
    "IPIP"
    "KIFU_LNS"
    "NFV"
    "NOP_MCHOME"
    "P"
    "PE"
    "RAWIP"
    "RENATER_PEERING_L2"
    "RENATER_PEERING_L3"
    "SRV6"
    "TOR"
    "VPLS"
    "WLC"
    "GGSN"
  ];
  profileFlags =
    lib.genAttrs profiles (profile: [ "-DPROFILE_${profile}" ]);
  additionalFlags = {
    GEANT_TESTBED = {
      buildFlags = lib.optionals (lib.versionAtLeast bf-sde.version "9.7.1")
        ## See Issue P4C-3974 in 9.7.1 release notes
        [ ''-Xp4c="--disable-parse-depth-limit"'' ];
    };
    NOP_MCHOME = {
      buildFlags = lib.optionals (lib.versionAtLeast bf-sde.version "9.7.1")
        [ ''-Xp4c="--disable-parse-depth-limit"'' ];
    };
  };
  p4Profiles = builtins.mapAttrs (profile: profileFlag:
    {
      buildFlags = profileFlag
                   ++ additionalFlags.${profile}.buildFlags or [];
      bffwdFlags = additionalFlags.${profile}.bffwdFlags or [];
    }) profileFlags;
in p4Profiles
