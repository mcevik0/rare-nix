#!/bin/bash
git pull
wget https://raw.githubusercontent.com/mc36/freeRouter/master/changelog.txt
wget www.freertr.net/rtr.jar
export MSG=`java -jar rtr.jar test changelog source ./changelog.txt state update-freerouter.txt pure | head -n -1`
echo "changes:
$MSG
"
rm rtr.jar
rm changelog.txt
rm reload.log
export VER=`curl https://raw.githubusercontent.com/mc36/freeRouter/master/src/rtr.txt 2>/dev/null`
echo version = $VER
export CMT=`curl -H "Accept: application/vnd.github.VERSION.sha" https://api.github.com/repos/mc36/freeRouter/commits/master 2>/dev/null`
echo commit = $CMT
export SUM=`nix-prefetch-url --unpack https://github.com/mc36/freeRouter/archive/$CMT.tar.gz 2>/dev/null | tail -1`
echo sha256 = $SUM
export FIL=./overlay/freerouter/repo.nix
cat > $FIL << EOF
{ fetchFromGitHub }:

{
  version = "$VER";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "$CMT";
    sha256 = "$SUM";
  };
}
EOF
cat $FIL
git add .
git commit -m "bumping freerouter to $VER"
git push
