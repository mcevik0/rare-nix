{ fetchgit }:

{
  version = "21.11.16";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "cca66f";
    sha256 = "03b0ydhf15lcwyv3xh44spvbyb6wcfn84ni835ixbfpi63nkg7dy";
  };
}
