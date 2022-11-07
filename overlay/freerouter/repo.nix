{ fetchFromGitHub }:

{
  version = "22.11.6";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "685b3f170727ead05a7cdee6f60c4b1cb55fea55";
    sha256 = "0lx5q24bznxi772ajrwnl0hrn22rknyjjh9mxgqnfjsvmz5ahf7i";
  };
}
