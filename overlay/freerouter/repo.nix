{ fetchFromGitHub }:

{
  version = "22.8.6";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "640f4da03bafd55d051d30f76ae0c443736a8f8b";
    sha256 = "1vdpfnsxrwsp0cn0ipmv5h26hbc5wf37aily3gwciawj698qd3cf";
  };
}
