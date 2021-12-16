#!/bin/sh
set -e
[ $# -eq 1 ]
profile=$(cat $1)
@CHECK_PROFILE@
@WRAPPERS@/bin/bf_router_${profile}-module-wrapper
