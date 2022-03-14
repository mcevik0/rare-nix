{ fetchFromGitHub }:

{
  version = "22.03.14";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "c97baa";
    sha256 = "17av4za1mmn82ax6lwz8riwr9qlc17cb8a0vfqinkwr4al26b8fd";
  };
}
