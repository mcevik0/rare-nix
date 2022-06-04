{ gcc10Stdenv, clang_10, fetchFromGitHub, libpcap, libbpf, libbsd, openssl,
  dpdk, numactl, makeWrapper, lib, iproute }:

let
  repo = import ./repo.nix { inherit fetchFromGitHub; };
in gcc10Stdenv.mkDerivation (repo // {
  pname = "freerouter-native";

  buildInputs = [ makeWrapper libpcap libbpf libbsd openssl dpdk numactl clang_10 ];

  NIX_LDFLAGS = "-ldl -lnuma -lrte_telemetry -lrte_mbuf -lrte_kvargs -lrte_eal";
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  buildPhase = ''
    set -e

    mkdir binTmp
    pushd misc/native
    substituteInPlace p4dpdk.c --replace '<dpdk/' '<'
    sh -e ./c.sh
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp binTmp/*.bin $out/bin
    wrapProgram $out/bin/tapInt.bin \
      --set PATH "${lib.strings.makeBinPath [ iproute ]}"
  '';
})
