{ fetchFromGitHub }:

{
  version = "23.7.15";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "bd89d1d0fbd7d044704f1995c5a8cc967682072c";
    sha256 = "0mc92vrs516ypr8grh2jln9ijmpqf8xqwcjm2b2h7fyh7li5r9fc";
  };
}
