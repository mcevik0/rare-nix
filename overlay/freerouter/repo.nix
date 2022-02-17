{ fetchFromGitHub }:

{
  version = "22.2.14";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "f91e7f";
    sha256 = "1v1kviqpq62wh66r3zc5pcmb0j4w45najrcb4qa83cwzlpzd1saq";
  };
}
