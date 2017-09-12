#!/bin/bash
# remote machine:
# hkucs@202.45.128.164
# this script should be put on the remote machine

echo "secondary machine #5 : 202.45.128.164"

cd qemu

sudo killall -9 qemu-system-x86_64

sudo x86_64-softmmu/qemu-system-x86_64 -machine pc-i440fx-2.3,accel=kvm,usb=off \
-netdev tap,id=hn0,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown,\
colo_script=./scripts/colo-proxy-script.sh,forward_nic=eth6 -device virtio-net-pci,id=net-pci0,netdev=hn0 \
-drive if=none,driver=raw,file=/home/hkucs/colo_ubuntu_single.img,id=colo1,cache=none,aio=native \
-drive if=virtio,driver=replication,mode=secondary,throttling.bps-total-max=70000000,\
file.file.filename=/home/hkucs/active_disk.img,file.driver=qcow2,\
file.backing.file.filename=/home/hkucs/hidden_disk.img,\
file.backing.driver=qcow2,\
file.backing.backing.backing_reference=colo1,\
file.backing.allow-write-backing-file=on \
-vnc :7 -m 2048 -smp 2 -device piix3-usb-uhci -device usb-tablet -monitor stdio -incoming tcp:0:8888 \
-monitor telnet::4444,server,nowait
