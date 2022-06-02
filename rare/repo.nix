{ fetchgit }:

{
  version = "2022.06.01";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "74004942948e3df348651ec6864b8ad665165f4d";
    sha256 = "00ihf31b5w8knjf5l8xkav0xjcagdyr9dnghxa6m4957iv96wrsa";
  };
}
