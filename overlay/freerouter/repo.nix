{ fetchFromGitHub }:

{
  version = "22.3.28";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "81a77045f9b205c41ee7289da49c3d367a720646";
    sha256 = "04nmx67xskb40401mv2lcm2cgapa49s3zivfd9diqlskawz88xj3";
  };
}
