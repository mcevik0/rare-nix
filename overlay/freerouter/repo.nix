{ fetchFromGitHub }:

{
  version = "22.12.16";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "fc261bd0181caad2aad70aa6f26ad50a773e0674";
    sha256 = "0yvcsf06rsmgwsg85h7idqp6cqg2x4r3v4adh2lbvdzyq01bg0ik";
  };
}
