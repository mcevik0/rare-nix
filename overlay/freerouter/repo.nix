{ fetchFromGitHub }:

{
  version = "22.10.22";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "80d52caf2c10dc228caa0b243f18b88933850c0c";
    sha256 = "1z1n946ccgjxb0n3s4a4y2lw62brklidi7s20nx8zy05jprrnsk7";
  };
}
