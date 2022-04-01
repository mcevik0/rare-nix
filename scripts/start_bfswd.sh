#!/bin/sh
set -e
## The mandatory first argument must be a file that contains the name
## of the P4 profile to use
[ $# -ge 1 ]
profile=$(cat $1)
@CHECK_PROFILE@
echo "Using bf_router profile \"$profile\""
## An optional second argument must be a directory where bf-switchd
## can write its bf_drivers.log and zlog-cfg-cur files
[ $# -eq 2 ] && cd $2
## Make this shell the leader of a process group for all child
## processes
set -m
@WRAPPERS@/bin/bf_router_${profile}-module-wrapper
