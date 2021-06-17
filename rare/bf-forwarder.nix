{ bf-sde, fetchgit, sal_modules }:

let
  repo = import ./repo.nix { inherit fetchgit; };
  bf-drivers-runtime = bf-sde.pkgs.bf-drivers-runtime;
  python = bf-drivers-runtime.pythonModule;
in python.pkgs.buildPythonApplication rec {
  inherit (repo) version src;
  pname = "bf_forwarder";

  propagatedBuildInputs = [
    bf-drivers-runtime sal_modules
  ];

  preConfigure = ''
    cd bfrt_python
  '';
}
