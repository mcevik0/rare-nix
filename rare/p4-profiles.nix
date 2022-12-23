{ pkgs, bf-sde }:

## P4 profiles to include in the release.  The attribute name defines
## the name of the profile as it appears in /etc/freertr/p4-profile on
## a running system.  Each profile can have two attributes
##
## <profile> = {
##   buildFlags = { default = [ ... ]; tofino = [ ... ]; ... };
##   bffwdFlags = [ ... ];
## }
##
## The buildFlags attribute must exist and specify an attribute set
## that contains P4 flags to use when compiling bf_router.p4. The set
## can contain an attribute "default" and one per supported compile
## target, i.e. tofino, tofino2 etc., each of which is a list of
## strings.  The actual set of flags used to compile a profile for a
## given target is the union of the default attribute and the
## target-specific attribute.
##
## Each profile has a functor associated with it which takes a
## platform as argument and returns the complete set of flags
## augmented by the platform-specific flags from ./platforms.nix
##
## The bffwdFlags attribute is optional.  If it is omitted,
## bf_forwarder.py is started directly with standard arguments.  If
## provided, it must be a list of valid arguments to be used for that
## specific profile, e.g.
##
##  some_profile = {
##    buildFlags = { ... };
##    bffwdFlags = [ "--some-flag <some-value>" ];
##  }
##
let
  lib = pkgs.lib;
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
    lib.genAttrs profiles (profile: { default = [ "-DPROFILE_${profile}" ]; });
  additionalFlags = {
    GEANT_TESTBED = {
      buildFlags = {
        tofino = lib.optionals (lib.versionAtLeast bf-sde.version "9.7.1")
          ## See Issue P4C-3974 in 9.7.1 release notes
          [ ''-Xp4c="--disable-parse-depth-limit"'' ];
      };
    };
    NOP_MCHOME = {
      buildFlags = {
        tofino = lib.optionals (lib.versionAtLeast bf-sde.version "9.7.1")
          [ ''-Xp4c="--disable-parse-depth-limit"'' ];
      };
    };
  };
  p4Profiles = builtins.mapAttrs (profile: attrs:
    let
      additionalFlags' = additionalFlags.${profile} or {};
    in
      {
        buildFlags = lib.zipAttrsWith (n: v: lib.flatten v)
          [ attrs additionalFlags'.buildFlags or {} ];
        bffwdFlags = additionalFlags'.bffwdFlags or [];
      } // {
        ## This functor returns an array of the full set of compiler
        ## flags used to build a profile for a given platform
        __functor = self: { platform }:
          let
            platformBuildFlags = import ./platforms.nix;
            target = bf-sde.platforms.${platform}.target;
          in lib.naturalSort ((self.buildFlags.default or []) ++
                              (self.buildFlags.${target} or []) ++
                              platformBuildFlags.${platform});
      }
  ) profileFlags;
in p4Profiles
