{ fetchFromGitHub }:

{
  version = "23.1.21";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "bd33f45e195214a7d35bb579e284fe8280e3dd38";
    sha256 = "015ix3im8cm3ym03qsbqpypamhpysazdmf1d87sc0a6i7kidlb2j";
  };
}
