{ fetchFromGitHub }:

{
  version = "22.7.16";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "43f47b5482a8a63c55dc2cadbdb8ff2143fc4460";
    sha256 = "0w3sv7y48smzrqf12r58ik655dzb8pz6s2dw63fghrp2pmwrz94v";
  };
}
