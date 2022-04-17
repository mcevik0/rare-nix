{ fetchFromGitHub }:

{
  version = "22.4.17";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "7e3cd1b9c7833ccc096a8b852c6315505c00f8e5";
    sha256 = "1gni96j2silq9afawsscqcx4y4silzh97dr9ga0bcipvrfc08kan";
  };
}
