{ fetchFromGitHub }:

{
  version = "22.7.23";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "537a00b88c9904ff2e4babb3804f4a0edafd3e3d";
    sha256 = "1ckd1nni569sfgiswzfhy63axqhbjwvjyp3hcp0rd7vl65l6hfgd";
  };
}
