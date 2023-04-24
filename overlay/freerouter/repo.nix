{ fetchFromGitHub }:

{
  version = "23.4.21";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "9dc545b753e767504f373b800a0189626e279dfc";
    sha256 = "sha256-uEq3ihxlcF+/ktusuwwkrebah0VJQE3qMppnfeTcfhw=";
  };
}
