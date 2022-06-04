{ fetchFromGitHub }:

{
  version = "22.6.4";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "a5750d9cc793ebecb760683d3f10e4088534921b";
    sha256 = "14bdrav4m575wx3kpbmxd0qc89gz36mll30p9ivy4yhj0afj8qfa";
  };
}
