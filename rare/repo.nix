{ fetchgit }:

{
  version = "2022.07.16";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "bd1c33d4924edaeebf1af2849c1b90b5869e182a";
    sha256 = "0vl8g78ngy3gl793kmsisp7ni6zn6x7bg0h54gzyn3w4vbz516qv";
  };
}
