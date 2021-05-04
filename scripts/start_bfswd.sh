#!/bin/sh
killall -9 bf_switchd
@WRAPPERS@/bin/bf_router_$1-module-wrapper
