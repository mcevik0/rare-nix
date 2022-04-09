{ fetchFromGitHub }:

{
  version = "22.4.9";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "713f0009bc30b80a1f929729d02a5638861c1c5b";
    sha256 = "1sh8zl9pah2wj33ch34bflc7xgmd5cdzg3hck4iz251vvsj81f1f";
  };
}
