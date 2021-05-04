#!/bin/bash

if=$1
shift

ifconfig $if up
exec $cmd "$@"
