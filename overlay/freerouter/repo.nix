{ fetchFromGitHub }:

{
  version = "22.6.18";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "3c023a8a8b2c0182656161a103cace74f5e45370";
    sha256 = "1ibgjw06nr031h6azgrrm6pr4krcb2djkvb23if3pmxkbbf0k1ki";
  };
}
