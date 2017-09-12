#!/bin/bash
# remote machine:
# hkucs@202.45.128.163
# this script should be put on the remote machine

cd qemu-mc

sudo killall -9 qemu-system-x86_64

sudo x86_64-softmmu/qemu-system-x86_64 /local/ubuntu/mc_ubuntu.qcow2 -m 16384 -smp 4 --enable-kvm -netdev tap,id=net0,ifname=tap0,script=/etc/qemu-ifup,downscript=no -device e1000,netdev=net0,mac=18:66:da:03:15:b1 -vnc :7 -incoming rdma:0:6666 \
-monitor telnet::4444,server,nowait
