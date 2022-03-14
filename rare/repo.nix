{ fetchgit }:

{
  version = "22.03.14";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "0c14c8";
    sha256 = "1masbbccjgn9blv7kcf0dsja2v0r4hky4p7k6fkffavkikflp58i";
  };
}
