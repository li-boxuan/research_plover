#!/bin/bash
# remote machine #7:
# hkucs@202.45.128.166
# this script should be put on the remote machine

cd qemu-mc

sudo killall -9 qemu-system-x86_64

sleep 3

sudo x86_64-softmmu/qemu-system-x86_64 /ubuntu-rdma/mc_ubuntu_rdma.qcow2 -m 16384 -smp 4 --enable-kvm -netdev tap,id=net0,ifname=tap0,script=/etc/qemu-ifup,downscript=no -device e1000,netdev=net0,mac=18:66:da:03:15:b1 -vnc :7 -incoming rdma:0:6666 \
-monitor telnet::4444,server,nowait
