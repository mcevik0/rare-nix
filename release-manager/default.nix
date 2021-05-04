{ stdenv, lib, version, nixProfile, coreutils, utillinux, gnused,
  gawk, jq, curl, systemd, gnutar, gzip, git, kmod, ncurses }:

stdenv.mkDerivation {
  pname = "release-manager";
  inherit version;
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    substitute ${./release-manager} $out/bin/release-manager \
      --subst-var-by PATH \
        "${lib.strings.makeBinPath [ coreutils utillinux gnused gawk
                                      jq curl systemd gnutar gzip git
                                      kmod ncurses ]}" \
      --subst-var-by PROFILE ${nixProfile}
    chmod a+x $out/bin/*
    patchShebangs $out/bin

    mkdir -p $out/etc/freertr
    substitute ${./rtr-hw.txt} $out/etc/freertr/rtr-hw.txt \
      --subst-var-by NIX_PROFILE ${nixProfile}
    substitute ${./rtr-sw.txt} $out/etc/freertr/rtr-sw.txt \
      --subst-var-by NIX_PROFILE ${nixProfile}

    mkdir -p $out/etc/snmp $out/var/lib/snmp
    cp ${./snmpd.conf} $out/etc/snmp/snmpd.conf
    cp ${./ifindex.init} $out/etc/snmp/ifindex.init
    cp ${./interface.conf} $out/var/lib/snmp/interface.conf
  '';
}
