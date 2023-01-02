{ fetchgit }:

{
  version = "2023.01.02";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "6a12e350193308752a2add03990eec05abbe364f";
    sha256 = "sha256-dqriNgjYVJ6nWd6+1ZluPU+IolRJsbnaLa9ky5XDRak=";
  };
}
