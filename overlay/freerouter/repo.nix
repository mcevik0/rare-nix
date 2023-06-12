{ fetchFromGitHub }:

{
  version = "23.6.8";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "6b5283d963a95aea89317a624ab989f13a49914d";
    sha256 = "02d0wcyix3hwfwikwrhhaq4k5r5w77rqdbg9y3gkvxrl9i5y2f7j";
  };
}
