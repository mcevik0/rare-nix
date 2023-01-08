{ fetchFromGitHub }:

{
  version = "23.1.8";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "392d1b1fbb7b6a74641acd69eb5ab9e1f7ae236c";
    sha256 = "02i10kabh67gvxpqii42hz64h07ygfxc0vfxaqmg3wz192kp9c9c";
  };
}
