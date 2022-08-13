{ fetchgit }:

{
  version = "2022.08.13";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "ce06255adfb6a7bc47e8bf27fc72e83823cb9121";
    sha256 = "1jzfi28sgiqqk8w9lq0y5z2zrx87kf7870dhggf63yvz7agqwr78";
  };
}
