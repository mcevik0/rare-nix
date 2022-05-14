{ fetchgit }:

{
  version = "2022.05.14";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "d41838e7ceae6b750927ffe0a1327c24a1aa792d";
    sha256 = "081lrlx8bi2l4s0h3hh6a0v1n90x7a847gfjmwk5n31vz71scmx0";
  };
}
