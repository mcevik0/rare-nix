{ fetchgit }:

{
  version = "2022.06.04";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "fa61e2eb32c317a848d94d9384cb6f1625942540";
    sha256 = "0j4gwzfnsjakzbj0fay1lkcfbanp5pmg3wz2m2172bd82bn3g504";
  };
}
