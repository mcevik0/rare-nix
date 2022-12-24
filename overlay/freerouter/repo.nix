{ fetchFromGitHub }:

{
  version = "22.12.24";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "3d1540793ef82fa7a3897d64a984070e3bb6e1aa";
    sha256 = "1npr83vhfch5iz3lszgdkdfbgj84cwqqvz8pmna666qai0dq1r6d";
  };
}
