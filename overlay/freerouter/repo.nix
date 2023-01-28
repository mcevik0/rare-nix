{ fetchFromGitHub }:

{
  version = "23.1.27";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "e9e5aa9809ed4662bfc8e7216af7802f4b8b9aa9";
    sha256 = "0p8790pk19grn2wgcmhw432vrf34b050fnjxsawpqfwm87gdjy6y";
  };
}
