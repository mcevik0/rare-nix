{ fetchFromGitHub }:

{
  version = "23.1.15";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "85229a9cd10879a98e10ae456b706e45673073f2";
    sha256 = "0di5q71r3qj2g19ail20a84y2k8k9fxmzbf7nzzsb6jx48ny6npc";
  };
}
