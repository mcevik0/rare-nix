#!/bin/bash
set -e

exec @BF_FORWARDER@/bin/bf_forwarder.py @FLAGS@ "$@"
