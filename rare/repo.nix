{ fetchgit }:

{
  version = "2023.01.28";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "3fa18fad0e63510e55ae8a8a0d90b4d2a0f4bff2";
    sha256 = "0l4jhnqwx6z5qcmsha7aapshnj5bg24dlwcc1ypbkxaj69r7bzgc";
  };
}
