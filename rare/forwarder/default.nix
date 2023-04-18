{ bf-sde, platform, pkgs }:

let
  repo = import ../repo.nix { inherit (pkgs) fetchgit; };
  bf-drivers-runtime = bf-sde.pkgs.bf-drivers-runtime;
  python = bf-drivers-runtime.pythonModule;
  pythonModules = import ./python.nix { inherit pkgs python; };
  ## The sal module currently only provides the salgrpcclient
  ## module. It resides in a non-public repository as requested by
  ## Stordis.  This seems a bit silly and it is expected that it will
  ## be moved to the RARE repository at some point. Note that the
  ## protobuf python bindings required by this module are provided by
  ## the bf-platform package specific to the APS BF2556 platform.
  sal_modules = pkgs.callPackage ./aps_bf2556-sal { inherit python; };
in python.pkgs.buildPythonApplication rec {
  inherit (repo) version src;
  pname = "bf_forwarder";

  propagatedBuildInputs = [
    bf-drivers-runtime sal_modules
  ] ++ (with pythonModules; [ yappi ])
  ++ pkgs.lib.optional (platform == "stordis_bf2556x_1t" &&
                        bf-sde.baseboardForPlatform platform != null)
    (if (pkgs.lib.versionOlder bf-sde.version "9.7.0") then
      bf-sde.pkgs.bf-platforms.aps_bf2556
     else
       bf-sde.pkgs.bf-platforms.aps_bf2556.salRefApp);

  preConfigure = ''
    cd bfrt_python
  '';
}
