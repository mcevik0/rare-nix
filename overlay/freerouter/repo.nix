{ fetchFromGitHub }:

{
  version = "22.10.15";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "5cfe80da0fef8c308dab16a72c1bf23c1f8347f4";
    sha256 = "19jxvw68lpxh9l3cb265y5i8a4br7m384n1msj5p0j1qashjgnx2";
  };
}
