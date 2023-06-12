{ fetchgit }:

{
  version = "2023.06.12";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "9aea363cd314af92a297a10eda8324ce5385ade2";
    sha256 = "090amsqfhsmd8m0mq8i799l53r3znq0m96ivvcm978kl6r08yk8q";
  };
}
