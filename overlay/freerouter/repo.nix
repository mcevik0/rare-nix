{ fetchFromGitHub }:

{
  version = "22.11.25";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "09ec51d58e056550ffbccfab302f9480c2835aab";
    sha256 = "0nd540afjph0bmvp0birlfgrjaasgx0q968xpv0pam2c0dw0j8r9";
  };
}
