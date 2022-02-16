#!/bin/sh
set -e
## The mandatory first argument must be a file that contains the name
## of the P4 profile to use
[ $# -ge 1 ]
profile=$(cat $1)
@CHECK_PROFILE@
## An optional second argument must be a directory where bf-switchd
## can write its bf_drivers.log and zlog-cfg-cur files
[ $# -eq 2 ] && cd $2
@WRAPPERS@/bin/bf_router_${profile}-module-wrapper
