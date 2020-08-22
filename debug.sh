#!/bin/bash
BUILDROOT_IMAGES_PATH="/home/rhydon/workspace/buildroot-2020.02.4/output/images"
VM_USERNAME="root"
VM_PASSWORD="123456"
CWD=`pwd`
REMOTE_DIR="/root/"`basename $CWD`
SSH_PORT=5555

cd $BUILDROOT_IMAGES_PATH

echo "Starting the vm"
qemu-system-x86_64 -enable-kvm -cpu host -s -kernel bzImage -m 2048 -hda rootfs.qcow2 -append "root=/dev/sda rw nokaslr" -net nic,model=virtio -net user,hostfwd=tcp::$SSH_PORT-:22 -loadvm first_snapshot &

# Busy loop for wait for the vm to startup and setup ssh
until sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT -q $VM_USERNAME@localhost exit
do 
echo "Waiting for vm setup"
done

echo "Moving the driver to the vm"
sshpass -p "$VM_PASSWORD" scp -P $SSH_PORT -r $CWD $VM_USERNAME@localhost:$REMOTE_DIR

sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost "find $REMOTE_DIR -iname *.ko -exec insmod {} \;"