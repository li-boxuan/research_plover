#!/bin/bash
# primary machine:
# hkucs@202.45.128.163
# this script should be put on the remote machine

echo "primary machine #4 : 202.45.128.163"

cd qemu

sudo killall -9 qemu-system-x86_64

sudo x86_64-softmmu/qemu-system-x86_64 -machine pc-i440fx-2.3,accel=kvm,usb=off \
-netdev tap,id=hn0,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown,\
colo_script=./scripts/colo-proxy-script.sh,forward_nic=eth1 -device virtio-net-pci,id=net-pci0,netdev=hn0 \
-boot c -drive if=virtio,id=disk1,driver=quorum,read-pattern=fifo,cache=none,aio=native,\
children.0.file.filename=/home/hkucs/colo_ubuntu_single.img,children.0.driver=raw \
-vnc :7 -m 2048 -smp 2 -device piix3-usb-uhci -device usb-tablet -monitor stdio -S \
-monitor telnet::4444,server,nowait
