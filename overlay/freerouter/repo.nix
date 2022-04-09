{ fetchFromGitHub }:

{
  version = "22.4.9";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "1e36e9356f55bbcbfec7b2e905da7678176f888f";
    sha256 = "1kmpr76yglsxphfrdxk8p4z05c37mpkksl5sip16y2chdbqxfiyx";
  };
}
