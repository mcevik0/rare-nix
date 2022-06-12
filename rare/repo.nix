{ fetchgit }:

{
  version = "2022.06.12";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "a6c17a48b1023e57788c13a839a664ca348b6c34";
    sha256 = "0rz3lpahfs2npssxg6mzm1i10mx0s2xysgybb41yxpqygaqwagp8";
  };
}
