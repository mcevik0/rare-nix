{ bf-sde, platform, pkgs }:

let
  platformBuildFlags = (import ./platforms.nix).${platform};
  profiles = import ./profiles.nix;
  buildP4 = profile: flags:
    pkgs.callPackage ./p4.nix {
      inherit bf-sde profile platform;
      buildFlags = flags.buildFlags ++ platformBuildFlags;
  };
in builtins.mapAttrs buildP4 profiles
