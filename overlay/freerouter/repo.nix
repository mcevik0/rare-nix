{ fetchFromGitHub }:

{
  version = "23.2.11";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "c8e456a8e37ea5d38cf8aa4d19c0b26209575af6";
    sha256 = "0jnxi5bl0kd3820ixzrqpasim0a33pm6l97hcg9vx4jgr8vy7lmn";
  };
}
