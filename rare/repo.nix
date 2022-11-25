{ fetchgit }:

{
  version = "2022.11.25";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "47cd06941e26b6a06a08d424a140e156443004fd";
    sha256 = "0536iffr1jzxz1d7c0k3sj7xwlyv5fgwlg6xz47a7g0bayr93765";
  };
}
