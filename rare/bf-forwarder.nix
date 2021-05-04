{ bf-sde, fetchgit, sal_modules, makeWrapper }:

let
  repo = import ./repo.nix { inherit fetchgit; };
  bf-drivers = bf-sde.pkgs.bf-drivers;
  python = bf-drivers.pythonModule;
in python.pkgs.buildPythonApplication rec {
  inherit (repo) version src;
  pname = "bf_forwarder";

  propagatedBuildInputs = [
    bf-drivers sal_modules
  ];
  buildInputs = [ makeWrapper ];

  preConfigure = ''
    cd bfrt_python
  '';

  postInstall = ''
    wrapProgram $out/bin/bf_forwarder.py \
      --set SDE ${bf-sde} --set SDE_INSTALL ${bf-sde}
  '';
}
