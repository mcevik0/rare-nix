{ stdenv, fetchFromGitHub, jdk, jre_headless, libpcap,
  libbsd, openssl, dpdk, numactl, zip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "freerouter-${version}";
  version = "21.12.02";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "812ea9";
    sha256 = "17gxs7jb9s0rcid6nq4y5pijnkggy2c3nlyww52xa0p08sw1syhd";
  };

  outputs = [ "out" "native" ];
  buildInputs = [ jdk jre_headless makeWrapper libpcap libbsd openssl dpdk numactl zip ];

  NIX_LDFLAGS = "-ldl -lnuma -lrte_telemetry -lrte_mbuf -lrte_kvargs -lrte_eal";
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  buildPhase = ''
    set -e
    mkdir binTmp
    pushd misc/native
    substituteInPlace p4dpdk.h --replace '<dpdk/' '<'
    sed -i -e '/CC=\"clang\"/d' c.sh
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
    sh -e ./cj.sh
    sh -e ./cp.sh
    cp rtr.jar $out/share/java/rtr.jar
    makeWrapper ${jre_headless}/bin/java $out/bin/freerouter \
      --add-flags "-Xmx2048m -cp $out/share/java/rtr.jar router"
    popd
    mkdir -p $native/bin
    cp binTmp/*.bin $native/bin
  '';

}
