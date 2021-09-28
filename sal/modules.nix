{ fetchBitbucketPrivate, bf-sde }:

let
  repo = import ./repo.nix { inherit fetchBitbucketPrivate; };
  bf-drivers-runtime = bf-sde.pkgs.bf-drivers-runtime;
  python = bf-drivers-runtime.pythonModule;
in python.pkgs.buildPythonPackage rec {
  pname = "sal-bf2556-t1";
  inherit (repo) version src;

  propagatedBuildInputs = [
    bf-drivers-runtime
    ## Pull in the sal_services_pb2*.py modules for salgrpcclient.py
    bf-sde.pkgs.bf-platforms.aps_bf2556
  ];

  preConfigure = ''
    cd modules
  '';
}
