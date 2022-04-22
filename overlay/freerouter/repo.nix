{ fetchFromGitHub }:

{
  version = "22.4.22";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "3612c357e60dd4b833b67d8d37f4ccf1e70b844c";
    sha256 = "14i5bifb3i8w20fwgzaw3n8lv9y93g78jacrywwndd2picwz552d";
  };
}
