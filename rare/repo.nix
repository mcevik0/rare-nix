{ fetchgit }:

{
  version = "2022.06.25";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "31fa7f3a98acbb737a8618710b065dc99c918e5a";
    sha256 = "15cdwqscx28pnqgwdmnakmlkrqcjp9chqf3bz3k8fmrpwwzcx7cy";
  };
}
