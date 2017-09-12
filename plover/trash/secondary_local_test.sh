#!/bin/bash
set -e

echo "Be sure two machines started and the election end"

ssh -t bli@gatekeeper.cs.hku.hk ssh hkucs@202.45.128.162 \
    "(


     ) | telnet localhost 4444"
