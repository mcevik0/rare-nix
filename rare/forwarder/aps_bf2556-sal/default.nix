{ callPackage, python }:

let
  fetchBitbucketPrivate = callPackage ./fetchbitbucket {};
in python.pkgs.buildPythonPackage rec {
  pname = "sal-bf2556-t1";
  version = "23c884";
  src = fetchBitbucketPrivate {
    url = "ssh://git@bitbucket.software.geant.org:7999/rare/rare-bf2556x-1t.git";
    rev = "${version}";
    sha256 = "152zalxx32j3hkzdzgl1xm3grc2s9gp7ab6nzyfbgcka9yrlcg7v";
  };

  preConfigure = ''
    cd modules
  '';
}
