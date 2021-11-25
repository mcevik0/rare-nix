{ fetchgit }:

{
  version = "21.10.31";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "70f745";
    sha256 = "1l0j2pzv0802iq4brw0cn6gi6jvh11ipkiipa71mz3fh0h11v3fi";
  };
}
