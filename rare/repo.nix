{ fetchgit }:

{
  version = "2022.06.13";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "1fe4361c888335d4616d86d6cf354bc4bae0bc1f";
    sha256 = "1s3kqdm79qkkm6vcd0zh1yd8dhwf5wsbz8bnsdcqcpfvxswxxqk6";
  };
}
