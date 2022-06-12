{ fetchFromGitHub }:

{
  version = "22.6.11";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "f5b6fa88e3bd51236b2c02fc2ec1c61a3ca4cab3";
    sha256 = "1a1k19qnjinr8kc0rksf8cvl6hsbv5v2w0z7szakqmcwvvg63vn0";
  };
}
