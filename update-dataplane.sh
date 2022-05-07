#!/bin/bash
git pull
export VER=`date +%Y.%m.%d`
echo version = $VER
export CMT=`curl "https://bitbucket.software.geant.org/rest/api/1.0/projects/RARE/repos/RARE/commits/master?limit=1" 2>/dev/null | jq -r ".id"`
echo commit = $CMT
export SUM=`nix-prefetch-url --unpack https://bitbucket.software.geant.org/rest/api/latest/projects/RARE/repos/rare/archive?format=tar 2>/dev/null | tail -1`
echo sha256 = $SUM
export FIL=./rare/repo.nix
cat > $FIL << EOF
{ fetchgit }:

{
  version = "$VER";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "$CMT";
    sha256 = "$SUM";
  };
}
EOF
cat $FIL
git add .
git commit -m "bumping dataplane to $VER"
git push
