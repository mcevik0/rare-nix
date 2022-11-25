{ fetchgit }:

{
  version = "2022.11.25";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "6829df6e79692c855c952d8eebae8555f29cb0e1";
    sha256 = "08lq0h0q613cpb7msd25pxs1g4sxnwpn07v6szik83p1pns78jv9";
  };
}
