{ fetchgit }:

{
  version = "21.12.16";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "78bcf6";
    sha256 = "1pwy1snj947ys7q7lmxjapnfr65km25z81hdc6ry1igjchw7mgbx";
  };
}
