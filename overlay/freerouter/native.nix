{ stdenv, clang, fetchFromGitHub, libpcap, libmnl, libbpf,
  libbsd, openssl, dpdk, numactl, makeWrapper, lib, iproute, llvm }:

let
  repo = import ./repo.nix { inherit fetchFromGitHub; };
in stdenv.mkDerivation (repo // {
  pname = "freerouter-native";

  buildInputs = [ makeWrapper libpcap libmnl libbpf libbsd openssl
                  dpdk numactl clang llvm ];

  NIX_LDFLAGS = "-ldl -lnuma -lrte_telemetry -lrte_mbuf -lrte_kvargs -lrte_eal";
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security -fno-stack-protector";

  buildPhase = ''
    set -e

    mkdir binTmp
    pushd misc/native
    substituteInPlace p4emu_dpdk.c --replace '<dpdk/' '<'
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
