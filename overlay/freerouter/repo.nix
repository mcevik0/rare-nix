{ fetchFromGitHub }:

{
  version = "22.7.9";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "98fe2c357141ae0190e957620382ceceaae2f0be";
    sha256 = "0i6nljajpnwj7n1xrqn6dp5h4v8hn3rbabzw2qfvw2nxwml50x10";
  };
}
