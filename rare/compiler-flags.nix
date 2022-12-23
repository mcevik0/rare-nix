## Create an array of all sets of P4 compiler flags for a specific P4
## target (tofino, tofino2 etc.) needed to create a release. This is
## intended to be used by the RARE table optimizier to make sure that
## an optimized profile doesn't break the RARE Nix build. Example
## usage from the RARE-NIX top-level directory for the PE profile:
##
## $ nix eval --json '(with import ./. {}; flagsForProfile "PE" "tofino")' | jq -r '(.[] | join(" "))'
## -DPROFILE_PE -DQUAD_PIPE
## -DDUAL_PIPE -DPROFILE_PE
## -DPROFILE_PE

{ profile, target, p4Profiles, supportedPlatforms, pkgs, bf-sde }:

let
  targetPlatforms = builtins.filter (
    platform: bf-sde.platforms.${platform}.target == target
  ) supportedPlatforms;
  mkFlags = platform:
    p4Profiles.${profile} { inherit platform; };
in pkgs.lib.unique (builtins.map mkFlags targetPlatforms)
