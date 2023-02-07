{ fetchgit }:

{
  version = "2023.02.07";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "cc7cfe6a8f3b78e6f64b884c2001daa7b82fff1e";
    sha256 = "03xbldg535d34jzk25vylkd9j5q0wq5lp4n517qb1jfvynj97rf3";
  };
}
