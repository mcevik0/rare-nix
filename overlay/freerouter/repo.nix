{ fetchFromGitHub }:

{
  version = "22.4.2";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "d34bb5800270a723266710a0749cb67376489399";
    sha256 = "0g1d5r171g6wvzxl7b5bikdk816ci5wgwc46kyydfi09cfsjxzpi";
  };
}
