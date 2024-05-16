{ fetchgit }:

{
  version = "2024.05.16";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "5fd05c3a0e5fd010503bb521e0e73c45e883be47";
    sha256 = "1sq4k11rgahavha2cjlsg0qfn33c1g1n8hzliv232w9dvs0kf9sb";
  };
}
