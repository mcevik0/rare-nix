{ fetchFromGitHub }:

{
  version = "22.10.26";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "46c750f4b8840af059c7333fe86a5be7fdcd3ed4";
    sha256 = "0y80x2cp0zxkzdra1jgvs0j6sq4h4972qgdd0hkacds21v2sjknz";
  };
}
