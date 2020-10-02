#!/bin/bash
trap "" 0 1 2 3 9 13 15

# User configuration
HOME_DIRECTORY="/home/spiderpig"
BUILDROOT_IMAGES_PATH="$HOME_DIRECTORY/workspace/buildroot/output/images"
VM_USERNAME="root"
VM_PASSWORD="root"
KERNEL_MODULE_NAME="kfile_over_icmp"

CWD=`pwd`
REMOTE_DIR="/root/"`basename $CWD`
SSH_PORT=5555

cd $BUILDROOT_IMAGES_PATH

if pgrep "qemu" > /dev/null
then
    echo "[+] QEMU is already running, continuing"
else
    echo "[+] running QEMU emulation"
    setsid qemu-system-x86_64 -enable-kvm -cpu host -s -kernel bzImage -m 2048 -hda rootfs.qcow2 -append "root=/dev/sda rw nokaslr" -smp 4 -net nic -net user,hostfwd=tcp::$SSH_PORT-:22,hostfwd=tcp::3333-:33 &
fi

# Busy loop for waiting for the vm to startup and setup ssh
until sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT -o StrictHostKeyChecking=no -q $VM_USERNAME@localhost exit
do 
    echo "[+] waiting for the VM to initialize"
    sleep 2
done

echo "[+] VM: initialized"

echo "[+] moving kernel module $KERNEL_MODULE_NAME to the vm"
sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost "rm -rf $REMOTE_DIR"
sshpass -p "$VM_PASSWORD" scp -P $SSH_PORT -r $CWD $VM_USERNAME@localhost:$REMOTE_DIR

echo "[+] unloading $KERNEL_MODULE_NAME from the kernel (if exists)"
sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost "rmmod $REMOTE_DIR/$KERNEL_MODULE_NAME.ko"

echo "[+] loading $KERNEL_MODULE_NAME to the kernel"
sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost "insmod $REMOTE_DIR/$KERNEL_MODULE_NAME.ko"

echo "[+] retrieving $KERNEL_MODULE_NAME .text section"
text_address=`sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost cat /sys/module/$KERNEL_MODULE_NAME/sections/.text`

# data_address=`sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost cat /sys/module/$KERNEL_MODULE_NAME/sections/.data`
# bss_address=`sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost cat /sys/module/$KERNEL_MODULE_NAME/sections/.bss`
# echo "add-symbol-file $KERNEL_MODULE_NAME.ko $text_address -s .data $data_address -s .bss $bss_address" > ~/.gdbinit

GDBINIT_PATH=$HOME_DIRECTORY/.gdbinit

if [ -f $GDBINIT_PATH.bak ]; then
    echo "[+] using an existing .gdbinit file"
    cp $GDBINIT_PATH.bak $GDBINIT_PATH
else
    echo "[+] creating a new .gdbinit file"
    rm -f $GDBINIT_PATH
    touch $GDBINIT_PATH
fi

echo "set auto-load safe-path /" >> $GDBINIT_PATH
echo "add-symbol-file $CWD/$KERNEL_MODULE_NAME.ko $text_address" >> $GDBINIT_PATH
echo "file $CWD/$KERNEL_MODULE_NAME.ko" >> $GDBINIT_PATH

echo "[+] launching SSH connection to the VM"
pkill gnome-terminal
/usr/bin/dbus-launch /usr/bin/gnome-terminal --working-directory=$CWD -e "sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost"
