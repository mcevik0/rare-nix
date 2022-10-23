{ fetchgit }:

{
  version = "2022.10.23";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "5b0e7593899e2271df3f654a14cf62ab440edba6";
    sha256 = "0g12ciz5w9kbiq9z3953vrpkyykgw7b7bfys9s4xwnr6x4bv2f4s";
  };
}
