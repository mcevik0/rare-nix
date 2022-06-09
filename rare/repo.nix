{ fetchgit }:

{
  version = "2022.06.09";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "ceda33ac1784d4350ecd417b05a0d864bd45a9fc";
    sha256 = "0spvbp1rr56yald1vb39xbj0hwbxh3hg3qsw6h22xixvjb33d3yq";
  };
}
