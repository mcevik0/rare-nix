{ fetchgit }:

{
  version = "2022.06.01";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "d33cd1def306bb2e88a641dbd7b343f748c4ce01";
    sha256 = "0r0d5q3cx429rx3x9kaa368ck9gkd7kxk9whvizhka7hc41s199k";
  };
}
