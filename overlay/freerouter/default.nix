{ clangStdenv, fetchFromGitHub, jdk, jre_headless, libpcap,
  libbpf, libbsd, openssl, dpdk, numactl, zip, makeWrapper,
  lib, iproute }:

clangStdenv.mkDerivation rec {
  pname = "freerouter";
  version = "22.2.14";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "f91e7f";
    sha256 = "1v1kviqpq62wh66r3zc5pcmb0j4w45najrcb4qa83cwzlpzd1saq";
  };

  outputs = [ "out" "native" ];
  buildInputs = [ jdk jre_headless makeWrapper libpcap libbpf libbsd openssl dpdk numactl zip ];

  NIX_LDFLAGS = "-ldl -lnuma -lrte_telemetry -lrte_mbuf -lrte_kvargs -lrte_eal";
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  buildPhase = ''
    set -e

    pushd src
    sh -e ./cj.sh
    sh -e ./cp.sh
    popd

    mkdir binTmp
    pushd misc/native
    substituteInPlace p4dpdk.h --replace '<dpdk/' '<'
    sh -e ./c.sh
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
    cp src/rtr.jar $out/share/java/rtr.jar
    makeWrapper ${jre_headless}/bin/java $out/bin/freerouter \
      --add-flags "-Xmx2048m -cp $out/share/java/rtr.jar net.freertr.router"

    mkdir -p $native/bin
    cp binTmp/*.bin $native/bin
    wrapProgram $native/bin/tapInt.bin \
      --set PATH "${lib.strings.makeBinPath [ iproute ]}"
  '';

}
