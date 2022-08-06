{ fetchgit }:

{
  version = "2022.08.06";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "6bac130071fb53c9a4fea2989a438207e253cbda";
    sha256 = "190l8dhc5qndsds7v31zifc1wjnli7a8gyaykbhpbqimjsj7rh1z";
  };
}
