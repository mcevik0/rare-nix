{ fetchFromGitHub }:

{
  version = "22.3.28";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "a0f68bc54d20c0fbf2834420f7723e7ca96c268a";
    sha256 = "0d7ixxx7zi6yk5aajyv0l1krpxsm3z4w1swr70j9mdlq40rlg7fz";
  };
}
