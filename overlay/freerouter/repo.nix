{ fetchFromGitHub }:

{
  version = "22.11.26";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "e48b2c9593c7662d9531c2dabe5f99c990c4ee93";
    sha256 = "0nyjng4105kpkxhlzlv6p3wksivj909ldjprvis5qf7wf8bg2n7c";
  };
}
