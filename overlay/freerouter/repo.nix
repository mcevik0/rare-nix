{ fetchFromGitHub }:

{
  version = "22.4.4";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "6f4d1af01af92892bb26e234ecb1e268793a4c88";
    sha256 = "1jr4k7k3bw6s35vadv5s553sazgyk3w9ay9w1zfc6slfq6jw2g6b";
  };
}
