{ fetchgit }:

{
  version = "2023.02.04";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "90dddfd685b7b070dd8f2b9b64c435f16b963c93";
    sha256 = "1hvpsm9bdnca14xj02h3n54bq0xx0a0gz1jgklsva2ql1473qh1j";
  };
}
