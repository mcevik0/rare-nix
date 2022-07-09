{ fetchgit }:

{
  version = "2022.07.09";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "f66b29e56c235f94cff2c3233ebcee951b19bdd1";
    sha256 = "1fdi64hbkyzpyasxxb59k4x80vx1fgl7kbmqmqjp2h61acfa2cf2";
  };
}
