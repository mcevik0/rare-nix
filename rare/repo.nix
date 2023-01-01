{ fetchgit }:

{
  version = "2023.01.01";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "1f1243af19fe044ae0906e78d68deeabf38682bd";
    sha256 = "1gb7vcggzb94hi9lkxaisw2c9wl2843pls698gjzbrckqnw653av";
  };
}
