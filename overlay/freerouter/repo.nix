{ fetchFromGitHub }:

{
  version = "22.7.1";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "ea3ffb52c154c28b4786282cdbcf04caf0b448ae";
    sha256 = "14mm4xs02wgm6mhxi06i4b5wgajzp4zi7ir4hz9ddz31qhaqnd6x";
  };
}
