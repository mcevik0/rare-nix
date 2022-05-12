{ fetchgit }:

{
  version = "2022.05.12";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "84d27aabefa1d9b9574acc3f3e3b6d27ceee95ba";
    sha256 = "0ka7nzpdl2aalv7gdp74gs6szfj3m15v9mdl821wnn70clpxizzp";
  };
}
