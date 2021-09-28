{ fetchBitbucketPrivate }:

rec {
  version = "c240c2";
  src = fetchBitbucketPrivate {
    ## Branch rare-nix-minimal
    url = "ssh://git@bitbucket.software.geant.org:7999/rare/rare-bf2556x-1t.git";
    rev = "${version}";
    sha256 = "1hd21izhxinn3iy0ddy7falb7c2wvpk666p8pbz2ymdikk38wnd6";
  };
}
