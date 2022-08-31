{ stdenv, jdk, jre_minimal, makeWrapper, runCommand, freerouter-jar }:

let
  modules = import (runCommand "freerouter-java-modules" {} ''
    IFS=,
    for dep in $(${jdk}/bin/jdeps --print-module-deps ${freerouter-jar}/rtr.jar); do
      deps="$deps \"$dep\""
    done
    echo "[ $deps ]">$out
  '');
  jre = jre_minimal.override {
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
    makeWrapper ${jre}/bin/java $out/bin/freerouter \
      --add-flags "-Xmx2048m -jar ${freerouter-jar}/rtr.jar"
  '';
}
