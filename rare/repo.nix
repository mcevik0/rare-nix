{ fetchgit }:

{
  version = "2023.02.08";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "2a376bd21218f4c4bae66b9ee43e7eeae86e81f5";
    sha256 = "0pnxlz3fzxdgjk9ys6j9idxy7ms4xj38fgx6s8badg1b4lblb7dn";
  };
}
