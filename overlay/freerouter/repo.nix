{ fetchFromGitHub }:

{
  version = "23.3.5";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "53d029666ff19fe43658c4c4d3319f613c80d97c";
    sha256 = "0darq6m6iibdwzcxqp2jv5hpg3dcsvziafwchlva276jli5mp7sb";
  };
}
