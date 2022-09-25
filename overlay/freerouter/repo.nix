{ fetchFromGitHub }:

{
  version = "22.9.24";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "7a18676c25d40ef30957e9be6ec2c15a3e955a74";
    sha256 = "1ih2x2b15bmz3y1jp227jqqjshzdcvgdqsim540lg23akj17mcyp";
  };
}
