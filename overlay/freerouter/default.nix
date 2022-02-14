{ clangStdenv, fetchFromGitHub, jdk, jre_headless, libpcap,
  libbpf, libbsd, openssl, dpdk, numactl, zip, makeWrapper }:

clangStdenv.mkDerivation rec {
  name = "freerouter-${version}";
  version = "22.2.14";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "a6069f";
    sha256 = "0h3jsmnlyxrzdld8nfb9ag9zr29z6h3qdbzfh6hkid7a8gk54cgx";
  };

  outputs = [ "out" "native" ];
  buildInputs = [ jdk jre_headless makeWrapper libpcap libbpf libbsd openssl dpdk numactl zip ];

  NIX_LDFLAGS = "-ldl -lnuma -lrte_telemetry -lrte_mbuf -lrte_kvargs -lrte_eal";
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  buildPhase = ''
    set -e
    mkdir binTmp
    pushd misc/native
    substituteInPlace p4dpdk.h --replace '<dpdk/' '<'
    sh -e ./c.sh
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
      --add-flags "-Xmx2048m -cp $out/share/java/rtr.jar net.freertr.router"
    popd
    mkdir -p $native/bin
    cp binTmp/*.bin $native/bin
  '';

}
