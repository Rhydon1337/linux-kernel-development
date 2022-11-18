#!/bin/bash
trap "" 0 1 2 3 9 13 15

# User configuration
HOME_DIRECTORY="HOME_DIRECTORY_PLACEHOLDER"
BUILDROOT_IMAGES_PATH="IMAGES_DIRECTORY_PLACEHOLDER"
VM_USERNAME="root"
VM_PASSWORD="ROOT_USER_PASSWORD_PLACEHOLDER"
KERNEL_MODULE_NAME="KERNEL_MODULE_NAME_PLACEHOLDER"

CWD=`pwd`
REMOTE_DIR="/root/"`basename $CWD`
SSH_PORT=5555
SNAPSHOT_NAME="SNAPSHOT_NAME_PLACEHOLDER"

cd $BUILDROOT_IMAGES_PATH

if pgrep "qemu" > /dev/null
then
    pkill -9 qemu
fi

echo "[+] running QEMU emulation"
setsid ./start_qemu.sh -loadvm $SNAPSHOT_NAME &

# Busy loop for waiting for the vm to startup and setup ssh
until sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT -o StrictHostKeyChecking=no -q $VM_USERNAME@localhost exit
do 
    echo "[+] waiting for the VM to initialize"
    sleep 1
done

echo "[+] VM: initialized"

echo "[+] moving kernel module $KERNEL_MODULE_NAME to the vm"
sshpass -p "$VM_PASSWORD" scp -P $SSH_PORT -r $CWD $VM_USERNAME@localhost:$REMOTE_DIR

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

echo "add-symbol-file $CWD/$KERNEL_MODULE_NAME.ko $text_address" >> $GDBINIT_PATH
echo "file $CWD/$KERNEL_MODULE_NAME.ko" >> $GDBINIT_PATH