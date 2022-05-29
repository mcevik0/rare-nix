{ fetchFromGitHub }:

{
  version = "22.5.28";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "9dc4bd32634dd6bbdd280834290480a53a3ab50e";
    sha256 = "0g8xm6kqklqf7gcac0l6lv2q9l2bx66xvs7qbn0sxkmq5v13y5qz";
  };
}
