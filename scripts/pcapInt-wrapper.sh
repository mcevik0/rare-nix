#!/bin/bash

if=$1

# Disable offloading features. The pcapInt utility is used to transfer
# packets as they appear on the wire to be consumed by the freerouter
# TCP/IP stack. Segmentation offloading interfers with that mechanism.

ethtool -K $if rx off
ethtool -K $if tx off
ethtool -K $if sg off
ethtool -K $if tso off
ethtool -K $if ufo off
ethtool -K $if gso off
ethtool -K $if gro off
ethtool -K $if lro off
ethtool -K $if rxvlan off
ethtool -K $if txvlan off
ethtool -K $if ntuple off
ethtool -K $if rxhash off
ethtool --set-eee $if eee off
ifconfig $if promisc

exec pcapInt.bin "$@"
