{ fetchFromGitHub }:

{
  version = "22.12.31";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "3f47e64cfc3aa8dded35a28e9ee9f06cd3f6a37d";
    sha256 = "0zmks0bfl29hbwn68z0xxfljv9h561shmmp9my1n7bbafbz2l0h6";
  };
}
