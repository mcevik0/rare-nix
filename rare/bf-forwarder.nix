{ bf-sde, runtimeEnv, fetchgit, sal_modules, makeWrapper }:

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
  buildInputs = [ makeWrapper ];

  preConfigure = ''
    cd bfrt_python
  '';

  postInstall = ''
    wrapProgram $out/bin/bf_forwarder.py \
      --set SDE ${runtimeEnv} --set SDE_INSTALL ${runtimeEnv}
  '';
}
