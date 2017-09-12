#!/bin/bash
set -e

ssh -t bli@gatekeeper.cs.hku.hk ssh hkucs@202.45.128.168 "bash ./primary_remote.sh"

