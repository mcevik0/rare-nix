{ fetchFromGitHub }:

{
  version = "23.6.24";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "1ffab931f83cba2907b946d62c12fc780015ff2b";
    sha256 = "18s4pypn6bvfbpll7ms7wycajjpq3psrh0zdzhphrrwr2s5rkkxh";
  };
}
