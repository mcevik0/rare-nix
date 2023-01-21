{ fetchgit }:

{
  version = "2023.01.21";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "554626230089032b5065d6b6749115dca3642597";
    sha256 = "0xj6fn6q2x0zmknd8pwbfx1h2cqr2g4d5q8w033m2bmlzixq4v2y";
  };
}
