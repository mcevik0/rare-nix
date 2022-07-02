{ fetchgit }:

{
  version = "2022.07.02";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "105ed625c9e451b57d66f27e5e9e4fd66925621b";
    sha256 = "0isnqn8fh7d3fp324mg0yykv7wyp8wrdl875jj0i9nhmma0nsjh4";
  };
}
