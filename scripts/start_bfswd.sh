#!/bin/sh
killall -9 @DAEMON@
@WRAPPERS@/bin/bf_router_$1-module-wrapper /var/log
