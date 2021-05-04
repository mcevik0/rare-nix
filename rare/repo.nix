{ fetchgit }:

{
  version = "21.03.01";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "f7d046";
    sha256 = "1h57rbq6j65a8z17srkbaikaqf0bs795ir2h2487fcl7pqkqk29i";
  };
}
