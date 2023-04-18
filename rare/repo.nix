{ fetchgit }:

{
  version = "2023.04.18";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "29ddc8f175a7301ebe2aee3a5032e472d5946a1c";
    sha256 = "04a43j01vvjkbyxw0wi03xyzfc2j8c6wr6nmvxdb7qjdfws3ylrz";
  };
}
