{ fetchFromGitHub }:

{
  version = "23.2.18";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "a57c206c73d6614cf59f9f7ed42822b962981686";
    sha256 = "0lliy110ssibjf3d8igw8sy25b9adkk3a4axj4lbrdi41ml0i3c2";
  };
}
