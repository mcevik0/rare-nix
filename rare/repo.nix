{ fetchgit }:

{
  version = "2022.11.07";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "4fddc11f33f8c5bfdc3ccee63fb420fecac8fa79";
    sha256 = "0cpq5qgjww4kp76jj10dg1a8rw6mjb36sqx4vn5wd6kx8mbmcyiv";
  };
}
