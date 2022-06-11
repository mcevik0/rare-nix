{ fetchFromGitHub }:

{
  version = "22.6.11";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "7bd8da6b01909fce6b5d204144dcd444297a56f8";
    sha256 = "0f8lwbcsvdnzn3k019grkvpw5whchcizjm5n09459gl87krhg0aj";
  };
}
