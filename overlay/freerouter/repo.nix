{ fetchFromGitHub }:

{
  version = "23.2.4";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "0268a31cdde91229b038c4d67319269e3b7bd7be";
    sha256 = "0j5q2ab5y85zb0dgr2c34ckb22z7vl1fd670hh55ijdc3930mx30";
  };
}
