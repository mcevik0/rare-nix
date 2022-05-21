{ fetchFromGitHub }:

{
  version = "22.5.21";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "38bffce5edaf8dab31d68527a763b6562bf9764e";
    sha256 = "1cr2w7x250nsrssqhq2y46qp3fkfhwd9s0ny17bhhdc12yq4kf27";
  };
}
