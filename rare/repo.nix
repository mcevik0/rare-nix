{ fetchgit }:

{
  version = "2022.07.16";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "3dc6269b4b369359926c97ded265db324a1bf25c";
    sha256 = "1g2pg139hykdxn2jcg7q8y2ab444s6i0swggp1vs8p04p8djcg5q";
  };
}
