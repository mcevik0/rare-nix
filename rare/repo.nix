{ fetchgit }:

{
  version = "2023.03.05";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "a88c7397109a4f8d7d2ffc99e76b9e551f394f61";
    sha256 = "04j6pagfdbm5fvayk3msjvfg5l6wjfpsm9r17i6xkvnrmh54pdgz";
  };
}
