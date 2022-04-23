{ fetchFromGitHub }:

{
  version = "22.4.23";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "91e1004b14d41bfb49d6b528a8c25624e6d20ee1";
    sha256 = "1nxcizbpybd28g6ni3b5n1hl4q1valp5h4i41m3j2q2pblz2nsys";
  };
}
