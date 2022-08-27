{ fetchgit }:

{
  version = "2022.08.27";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "2bd114a47dbb4a5b5c4511a7601aa2966afd238d";
    sha256 = "0q0bls272bqpyxkc3paqcgbgpj8lzr417zznsi5kayv8pskl6n52";
  };
}
