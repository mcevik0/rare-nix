{ fetchFromGitHub }:

{
  version = "22.3.31";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "75af6f";
    sha256 = "00r6b9bqi1l1nq6w78q4n955bbmr60r3lbia6nww9bcfz7nnb7hx";
  };
}
