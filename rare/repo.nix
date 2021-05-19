{ fetchgit }:

{
  version = "21.05.19";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "57466b";
    sha256 = "0srqyids2l4zxgj83wwzds2423sm1npcsxkv8a87k22mxihav6bw";
  };
}
