{ fetchFromGitHub }:

{
  version = "22.4.7";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "0725606";
    sha256 = "1qnkq4ry2r0hsfczbww80kgmwmjhv8bkgyrb1l6qy2cvnf62lmk8";
  };
}
