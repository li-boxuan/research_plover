#!/bin/bash
# remote machine:
# hkucs@202.45.128.168  RDMA4PAXOS
# this script should be put on the remote machine

set -e

# Step 1. Export absolute path to vm-ft
export VMFT_ROOT=/home/hkucs/vm-ft

# Step 2. Start qemu (primary machine side)

cd vm-ft/qemu/

sudo killall -9 qemu-system-x86_64

sudo LD_LIBRARY_PATH=$VMFT_ROOT/rdma-paxos/target:$LD_LIBRARY_PATH x86_64-softmmu/qemu-system-x86_64 -boot c -m 2048 -smp 2 -qmp stdio -vnc :7 -name secondary -enable-kvm \
-qmp tcp:localhost:4444,server,nowait \
-cpu qemu64,+kvmclock -device piix3-usb-uhci -drive if=none,id=colo-disk0,file.filename=/home/hkucs/ubuntu-ye.img,driver=raw,node-name=node0 \
-drive if=virtio,id=active-disk0,driver=replication,mode=secondary,file.driver=qcow2,top-id=active-disk0,file.file.filename=/home/hkucs/active_disk.img,file.backing.driver=qcow2,file.backing.file.filename=/home/hkucs/hidden_disk.img,file.backing.backing=colo-disk0 \
-netdev tap,id=hn0,vhost=off,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown -device e1000,netdev=hn0,mac=52:a4:00:12:78:66 \
-chardev socket,id=red0,path=/dev/shm/mirror.sock -chardev socket,id=red1,path=/dev/shm/redirector.sock \
-object filter-redirector,id=f1,netdev=hn0,queue=tx,indev=red0 -object filter-redirector,id=f2,netdev=hn0,queue=rx,outdev=red1 -incoming tcp:10.22.1.9:8888 -global kvm-apic.vapic=false
