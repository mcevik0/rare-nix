{ fetchFromGitHub }:

{
  version = "22.4.12";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "38ab07";
    sha256 = "1m79vvhqhyxiawkxvz4srx45gc8yvxi95kjz650yznh3wqy5pl9w";
  };
}
