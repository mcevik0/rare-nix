{ fetchFromGitHub }:

{
  version = "22.8.13";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "f4cda565fe423bf627f0f602ce592990f679697f";
    sha256 = "1qxg8nwiaw2l5cssbkcd6j4k627hg9qxmmj6mnyfkjgh5qzvdg8w";
  };
}
