{ support, version, nixProfile, p4Profiles, defaultProfile, bash }:

assert builtins.hasAttr defaultProfile p4Profiles;
support.mkReleaseManager {
  inherit version nixProfile;
  apiType = "bitbucket";
  repoUrl = "https://bitbucket.software.geant.org/scm/rare/rare-nix.git";
  apiUrl = "https://bitbucket.software.geant.org/rest/api/1.0/projects/RARE/repos/RARE-NIX";
  activationCode = ./activation.sh;
  installCmds = ''
    substituteInPlace $out/bin/release-manager \
      --subst-var-by BASH ${bash}/bin/bash
    mkdir -p $out/etc/freertr
    substitute ${./rtr-sw.txt} $out/etc/freertr/rtr-sw.txt \
      --subst-var-by NIX_PROFILE ${nixProfile} \
      --subst-var-by DEFAULT_PROFILE ${defaultProfile}
    echo ${defaultProfile} >$out/etc/freertr/p4-profile
    mkdir -p $out/etc/snmp $out/var/lib/snmp
    cp ${./snmpd.conf} $out/etc/snmp/snmpd.conf
    cp ${./ifindex.init} $out/etc/snmp/ifindex.init
    cp ${./interface.conf} $out/var/lib/snmp/interface.conf
  '';
  patches = [ ./install-experimental.patch ];
}
