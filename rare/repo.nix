{ fetchgit }:

{
  version = "21.11.16";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "bf84cd";
    sha256 = "18qqzzzyfgkl7asily06lr9cbcd8qd1f8al5jl6nqcd5f0f7qa3k";
  };
}
