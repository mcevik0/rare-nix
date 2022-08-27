{ fetchFromGitHub }:

{
  version = "22.8.24";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "5f077157eddb9b129e67d0100f26b4dcdab02b44";
    sha256 = "15b62h0x7wj5ihgpi58nscyab47xxxamwwi2f0nbwayhk0z93jsh";
  };
}
