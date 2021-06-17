{ fetchgit }:

{
  version = "17.06.21";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "6d4211";
    sha256 = "0yif655kchsg12i5d20kz8hq229a0kb4r01x4jkn59rqw9vsia6h";
  };
}
