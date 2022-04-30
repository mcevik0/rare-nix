{ fetchFromGitHub }:

{
  version = "22.4.30";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "8951c75291460dd8b87a3646c04eb217d102f143";
    sha256 = "1dysiq5mkr8grmk9qmlbg2mfg9h2zhbqfyyjqmbz6jjzs7532rxv";
  };
}
