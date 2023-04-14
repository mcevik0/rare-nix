{ fetchgit }:

{
  version = "2023.04.04";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "7fd2b1b26d2c0bd52e01031f59577d83f97107a6";
    sha256 = "1q0pxzr50i1vvn4kydyqbpi5c6bgznzm6rfi5m6az4n6dk7w3qxc";
  };
}
