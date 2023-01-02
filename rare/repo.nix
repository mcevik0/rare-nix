{ fetchgit }:

{
  version = "2023.01.02";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "e1d8740162dbaafec9ebd5a5ae23c5c90f56b062";
    sha256 = "sha256-HxBm1A1Dnr2oEyGXU6N4BsoXP+Sgro8Oana05eQBVPk=";
  };
}
