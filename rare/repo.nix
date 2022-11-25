{ fetchgit }:

{
  version = "2022.11.25";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "edaec31d0128a5c3cb0decce93d064eaf20042ab";
    sha256 = "18r33q7cvjls23bvw49s6isrcmdabl715lhmzcqw5dcx6gdvdxk7";
  };
}
