{ fetchgit }:

{
  version = "2022.05.07";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "8bdd9fcdf48317c1ad975758b4ee6b834ddf1e35";
    sha256 = "1j6zwfy95mcgqyv4zfiw5y96krc0if1vy5bsx2wsr4s6d9f4gbpn";
  };
}
