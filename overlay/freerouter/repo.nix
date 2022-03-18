{ fetchFromGitHub }:

{
  version = "22.03.18";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "df4e5f";
    sha256 = "0cp85sdnnad5zvdirqcgnfkivc9ih0x68qvxpdkvgxngxqjcbl1c";
  };
}
