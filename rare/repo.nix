{ fetchgit }:

{
  version = "2022.10.27";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "3d6d7362973ee29b4bd58da3285fbaf9bb26375b";
    sha256 = "1l0bpq2nfg8b51jgjhy6pxnhjklqk9shkhxf72v5wkcy7nl94fsz";
  };
}
