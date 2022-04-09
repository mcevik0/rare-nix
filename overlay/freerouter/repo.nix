{ fetchFromGitHub }:

{
  version = "22.4.9";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "a9d06f83de43f659850ed177dc8d89c909d4d15e";
    sha256 = "1zk8mb096c5hl9j4z7gw6dmjwg6hhkklnrinhmf10andcxh5bb94";
  };
}
