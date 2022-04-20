{ fetchgit }:

{
  version = "22.04.20";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "65bbb8";
    sha256 = "0702ry824sjnjd7rsb2dbm5qxvkdc2b6yvb2n17fqrplmq3wh2kc";
  };
}
