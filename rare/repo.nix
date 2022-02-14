{ fetchgit }:

{
  version = "22.02.14";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "35e152";
    sha256 = "1s80kv9xaw9549qwpdxi21915ccp69a25a8g1drzhzvzl8pkvfk6";
  };
}
