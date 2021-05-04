{ stdenv, fetchFromGitHub, jdk, jre_headless, libpcap,
  libbsd, openssl, dpdk, numactl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "freerouter-${version}";
  version = "21.04.06";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "6e1607";
    sha256 = "0mkg62cgz9jmlfwz0vdpk1x6nw99mg25pkj4hwql8zm22bh1dfar";
  };

  outputs = [ "out" "native" ];
  buildInputs = [ jdk jre_headless makeWrapper libpcap libbsd openssl dpdk numactl ];

  NIX_LDFLAGS = "-ldl -lnuma -lrte_telemetry -lrte_mbuf -lrte_kvargs -lrte_eal";

  buildPhase = ''
    set -e
    mkdir binTmp
    pushd misc/native
    substituteInPlace p4dpdk.c --replace '<dpdk/' '<'
    sh -e ./c.sh
    popd
    pushd src
    javac router.java
    popd
  '';

  installPhase = ''
    pushd src
    mkdir -p $out/bin
    mkdir -p $out/share/java
    jar cf $out/share/java/freerouter.jar router.class */*.class
    makeWrapper ${jre_headless}/bin/java $out/bin/freerouter \
      --add-flags "-Xmx2048m -cp $out/share/java/freerouter.jar router"
    popd
    mkdir -p $native/bin
    cp binTmp/*.bin $native/bin
  '';

}
