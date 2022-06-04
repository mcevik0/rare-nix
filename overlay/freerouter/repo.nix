{ fetchFromGitHub }:

{
  version = "22.6.4";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "9cb74447cfbb98e45d4b2c980692346307790d6d";
    sha256 = "0867l7pnfa247bcml4y6qlr6nq6dmx7jy5l8a2ws0mlp657am9j2";
  };
}
