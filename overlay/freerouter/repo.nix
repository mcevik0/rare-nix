{ fetchFromGitHub }:

{
  version = "22.6.25";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "a0b70cbe4a19be211a92830a02b1ef9918de5754";
    sha256 = "1rkpfii79cqs8jbc0lcxnnzc2pp3ksnq06rxr1w96wvlfk892c38";
  };
}
