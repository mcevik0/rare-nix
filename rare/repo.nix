{ fetchgit }:

{
  version = "2022.10.13";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "09e14ee49d419753b966bdab4d55346ee6b11daf";
    sha256 = "0wza0p6r7lxslclv7kxm6a2d194y4nl2fk9vakwh95s5z6glvxp8";
  };
}
