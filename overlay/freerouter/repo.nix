{ fetchFromGitHub }:

{
  version = "22.3.28";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "82639cbb3cbca7f464d43fa0658792c3b0ad5a3e";
    sha256 = "03prpacjc3r8vrqz583066xjz3yl626nks780580jii6wbqip1jd";
  };
}
