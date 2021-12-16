{ callPackage, python }:

let
  fetchBitbucketPrivate = callPackage ./fetchbitbucket {};
in python.pkgs.buildPythonPackage rec {
  pname = "sal-bf2556-t1";
  version = "8ebae7";
  src = fetchBitbucketPrivate {
    url = "ssh://git@bitbucket.software.geant.org:7999/rare/rare-bf2556x-1t.git";
    rev = "${version}";
    sha256 = "1ihxkfs5z350090x4da5cd0alh0axdj0rlgb7d6lk2339bjb7wa1";
  };

  preConfigure = ''
    cd modules
  '';
}
