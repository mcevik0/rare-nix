{ fetchgit }:

{
  version = "2023.02.11";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "98b07bfcf736d599dd166de0ddc3dbee85c5563e";
    sha256 = "0xd10zvpgb7aqa03ap0y5iz455i9fhg4s79rv0ahdksjdafx4frd";
  };
}
