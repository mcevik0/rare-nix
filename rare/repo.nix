{ fetchgit }:

{
  version = "2022.11.25";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "b0c47c54652ac9223d58b55909f8c09556bda020";
    sha256 = "184hzd1574g8s67xw4d113zyy66l987013zdr707mg2awyzxcp0y";
  };
}
