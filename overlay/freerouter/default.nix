{ stdenv, jdk, makeWrapper, callPackage, runCommand, freerouter-jar }:

let
  modules = import (runCommand "freerouter-java-modules" {} ''
    IFS=,
    for dep in $(${jdk}/bin/jdeps --print-module-deps ${freerouter-jar}/rtr.jar); do
      deps="$deps \"$dep\""
    done
    echo "[ $deps ]">$out
  '');
  jre_minimal = callPackage ../jre.nix {
    inherit jdk modules;
  };
in stdenv.mkDerivation {
  pname = "freerouter";
  inherit (freerouter-jar) version;
  src = null;
  phases = [ "installPhase" ];

  buildInputs = [ makeWrapper ];
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${jre_minimal}/bin/java $out/bin/freerouter \
      --add-flags "-Xmx2048m -jar ${freerouter-jar}/rtr.jar"
  '';
}
