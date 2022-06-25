{ fetchFromGitHub }:

{
  version = "22.6.25";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "07ea7396fd2c9ca21e3305ccff3dbfbf5b8491ae";
    sha256 = "1y4733a5ci1pxbj21l9rmk1zhqk72hs9g9mrpdq43f2symxp0ndv";
  };
}
