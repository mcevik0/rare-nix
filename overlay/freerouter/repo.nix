{ fetchFromGitHub }:

{
  version = "22.7.16";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "dbb294f41e6335f09b2118d87483048c7882b0a0";
    sha256 = "19apbifiab8d00pmqmjp7vl1ml74hjhfryc9sq6ymh7ll2ccvq5n";
  };
}
