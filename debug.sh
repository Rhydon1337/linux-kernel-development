#!/bin/bash
BUILDROOT_IMAGES_PATH="/home/rhydon/workspace/buildroot-2020.02.4/output/images"
VM_USERNAME="root"
VM_PASSWORD="123456"
CWD=`pwd`

cd $BUILDROOT_IMAGES_PATH

echo "Starting the vm"
sudo qemu-system-x86_64 -enable-kvm -cpu host -s -kernel bzImage -m 2048 -hda rootfs.qcow2 -append "root=/dev/sda rw nokaslr" -net nic,model=virtio -net user,hostfwd=tcp::5555-:22 -loadvm first_snapshot &

sleep 1

echo "Moving the driver to the vm"
sshpass -p "$VM_PASSWORD" scp -P 5555 -r $CWD $VM_USERNAME@localhost:/root/