{ fetchgit }:

{
  version = "2022.06.18";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "e1122d42f31af01148f364ae9121e9cbd4c36fff";
    sha256 = "03l1j3654q7rx2ldzlwbx459dn4amv57s2v2qgs3lr1i0y4z75bk";
  };
}
