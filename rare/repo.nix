{ fetchgit }:

{
  version = "10.10.21";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "2cc922";
    sha256 = "0a7ivrq5gv95493im65wjqp4wbzrp9r3b57kpdx4yrddlnjja7r1";
  };
}
