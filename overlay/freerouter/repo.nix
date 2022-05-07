{ fetchFromGitHub }:

{
  version = "22.5.7";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "f2849172fe88353d5c83b384ccaf10936d363368";
    sha256 = "1r23hgnmgcb69734rzvn57r5k86y5slh2q5qjcw6ffgqlb5ib6ak";
  };
}
