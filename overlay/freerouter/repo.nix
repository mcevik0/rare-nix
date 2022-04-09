{ fetchFromGitHub }:

{
  version = "22.4.9";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "e4a26021e4454652c1ae5a137bf205046657c97f";
    sha256 = "0ylkl4jy20gwfdvw1rn1jdjsmwrvr12h5avb9fb14ic4lqvyz31l";
  };
}
