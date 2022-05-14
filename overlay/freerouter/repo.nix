{ fetchFromGitHub }:

{
  version = "22.5.14";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "47c6bd6a79bc508e36aca1be1cbb5ddb1c89efec";
    sha256 = "1wd7x8mxxgm9iqh1hz12s66y9q5zs128w9k9lgyljydwcs8qxg6g";
  };
}
