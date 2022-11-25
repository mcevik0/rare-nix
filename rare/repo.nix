{ fetchgit }:

{
  version = "2022.11.25";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "b06a4c69301abffb15730e1dc8a7a262f199726c";
    sha256 = "1rpslw8f7kck3rivrkl962dzs6v9vajp17dclad58qf275d8xrlc";
  };
}
