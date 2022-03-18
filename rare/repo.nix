{ fetchgit }:

{
  version = "22.03.18";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "b8ce98";
    sha256 = "0ad322j3pj1hcn45376nfwy6xwvc3xmhyxa5azxvrsm998gipid2";
  };
}
