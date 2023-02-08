{ fetchgit }:

{
  version = "2023.02.08";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "8ec3d39f1ec325aa8eb04389eff3cfa960d06385";
    sha256 = "09mca27wr6cy28g158km2m116d5j6ajginwznzwl6vsy1xpx4jim";
  };
}
