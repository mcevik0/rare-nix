#!/bin/bash
set -e
profile=$(cat $1)
shift
@CHECK_PROFILE@
if [ -e @WRAPPERS@/bin/bf_forwarder_${profile} ]; then
    forwarder=@WRAPPERS@/bin/bf_forwarder_${profile}
else
    forwarder=@BF_FORWARDER@/bin/bf_forwarder.py
fi
exec $forwarder "$@" --p4-program-name=bf_router_${profile}
