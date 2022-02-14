{ bf-sde, platform, p4Profiles, pkgs }:

let
  platformBuildFlags = (import ./platforms.nix).${platform};
  buildP4 = profile: flags:
    pkgs.callPackage ./p4.nix {
      inherit bf-sde profile platform;
      buildFlags = flags.buildFlags ++ platformBuildFlags;
  };
in builtins.mapAttrs buildP4 p4Profiles
