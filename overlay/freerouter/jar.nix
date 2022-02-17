{ stdenv, fetchFromGitHub, jdk, zip }:

let
  repo = import ./repo.nix { inherit fetchFromGitHub; };
in  stdenv.mkDerivation (repo // {
  pname = "freerouter-jar";
  buildInputs = [ jdk zip ];
  buildPhase = ''
    pushd src
    sh -e ./cj.sh
    sh -e ./cp.sh
    popd
  '';
  installPhase = ''
    mkdir $out
    cp src/rtr.jar $out
  '';
 })
