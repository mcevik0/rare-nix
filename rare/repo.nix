{ fetchgit }:

{
  version = "2023.07.15";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "9608cf8dc9e83d43e9b45dd697e32d2bcd1fa9af";
    sha256 = "0x74nws0ml90zn9n0d2p3jrpakc1j8n2z6gf89d4hhp0jv2i38mh";
  };
}
