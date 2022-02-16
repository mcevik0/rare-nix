#!/bin/bash

if=$1
shift

## The device is created by the bf_kpkt kernel module, which is loaded
## asynchronously by the script that launches bf_switchd.
while ! ifconfig $if >/dev/null 2>&1; do
    echo "Waiting for $if to become ready"
    sleep 1
done
echo "Interface $if is ready"
ifconfig $if up
ifconfig $if mtu 9710
ifconfig $if promisc
exec $cmd "$@"
