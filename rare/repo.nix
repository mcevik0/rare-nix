{ fetchgit }:

{
  version = "2023.04.24";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "a03aadcd246a645d72b258d17d869f7149e06d5f";
    sha256 = "sha256-sPeDC7OKp7OVeOMjXYEK1JbPylvz0d1E5PcWWnq6iIc=";
  };
}
