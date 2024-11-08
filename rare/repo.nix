{ fetchgit }:

{
  version = "2024.11.08";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "f6b5d0f237428cf74d2de7963b43cdca07e37066";
    sha256 = "002nz5rvf2g9q5987cya4jnm45sfhcvgsxvq0vm7209ld0agfrvj";
  };
}
