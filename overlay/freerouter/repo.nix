{ fetchFromGitHub }:

{
  version = "23.3.11";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "73675804b1f795fe67c6b7c52736899dbec860dc";
    sha256 = "0sns7m758kv7zq7235v6av849ngwnxf8ipc1v86hyc3nbc4nvkmk";
  };
}
