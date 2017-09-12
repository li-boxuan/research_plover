#!/bin/bash
set -e

echo "Be sure two machines started and the election end"

ssh -t bli@gatekeeper.cs.hku.hk ssh hkucs@202.45.128.162 "\
    sudo modprobe ifb numifbs=100  # (or some large number);\
    sudo ip link set up ifb0  # <= corresponds to tap device 'tap0';\
    sudo tc qdisc add dev tap0 ingress;\
    sudo tc filter add dev tap0 parent ffff: proto ip pref 10 u32 match u32 0 0 action mirred egress redirect dev ifb0;"


ssh -t bli@gatekeeper.cs.hku.hk ssh hkucs@202.45.128.162 "\
    (
        {'execute':'qmp_capabilities'}
        { 'execute': 'human-monitor-command',
          'arguments': {'command-line': 'drive_add -n buddy driver=replication,mode=primary,file.driver=nbd,file.host=10.22.1.9,file.port=8889,file.export=colo-disk0,node-name=node0'}}
        { 'execute':'x-blockdev-change', 'arguments':{'parent': 'colo-disk0', 'node': 'node0' } }
        { 'execute': 'migrate-set-capabilities',
              'arguments': {'capabilities': [ {'capability'
        : 'x-colo', 'state': true } ] } }
        { 'execute': 'migrate', 'arguments': {'uri': 'tcp:10.22.1.9:8888' } }
        { 'execute': 'migrate-set-parameters' , 'arguments': { 'x-checkpoint-delay': 1 } }
    ) | telnet localhost 4444"
