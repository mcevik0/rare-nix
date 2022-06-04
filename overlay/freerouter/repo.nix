{ fetchFromGitHub }:

{
  version = "22.6.4";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "4cd6e4abb77950f23d2db4de526fc75538b21086";
    sha256 = "04lc72zjybr1yam2ka0v1k2c9qqpd9hvhiny88m1gdahwfdbnvkp";
  };
}
