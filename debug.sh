#!/bin/bash
trap "" 0 1 2 3 9 13 15

# User configuration
HOME_DIRECTORY="HOME_DIRECTORY_PLACEHOLDER"
BUILDROOT_IMAGES_PATH="IMAGES_DIRECTORY_PLACEHOLDER"

VM_USERNAME="root"
VM_PASSWORD="ROOT_USER_PASSWORD_PLACEHOLDER"
KERNEL_MODULE_NAME="KERNEL_MODULE_NAME_PLACEHOLDER"

CWD=`pwd`
REMOTE_DIR="/"`basename $CWD`
SSH_PORT=5555
SNAPSHOT_NAME="SNAPSHOT_NAME_PLACEHOLDER"
SNAPSHOT_CMDLINE_FILE="loadvm_cmdline"

cd $BUILDROOT_IMAGES_PATH

if pgrep "qemu" > /dev/null
then
    pkill -9 qemu
fi


if pgrep "gdb" > /dev/null
then
    pkill -9 gdb
fi


for pid in $(pidof -x debug.sh); do
    if [ $pid != $$ ]; then
        kill -9 $pid
    fi 
done


# Qemu processes need to shut down
# after being killed
# using the good ol' sleep as a hacky (but effective) patch
sleep 1

echo "loadvm $SNAPSHOT_NAME" > $SNAPSHOT_CMDLINE_FILE

echo "[+] running QEMU emulation"
setsid ./start-qemu.sh &

# Busy loop for waiting for the vm to startup and setup ssh
until sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT -o StrictHostKeyChecking=no $VM_USERNAME@localhost exit
do 
    echo "[+] waiting for the VM to initialize"
    sleep 1
done

echo "[+] VM: initialized"

echo "[+] reverting to snapshot: $SNAPSHOT_NAME"
socat OPEN:$SNAPSHOT_CMDLINE_FILE unix-connect:qemu-monitor-socket

echo "[+] moving kernel module $KERNEL_MODULE_NAME to the vm"
sshpass -p "$VM_PASSWORD" scp -P $SSH_PORT -r $CWD $VM_USERNAME@localhost:$REMOTE_DIR

echo "[+] loading $KERNEL_MODULE_NAME to the kernel"
sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost "insmod $REMOTE_DIR/$KERNEL_MODULE_NAME.ko"

echo "[+] retrieving $KERNEL_MODULE_NAME sections"
text_address=`sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost cat /sys/module/$KERNEL_MODULE_NAME/sections/.text`
data_address=`sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost cat /sys/module/$KERNEL_MODULE_NAME/sections/.data`
bss_address=`sshpass -p "$VM_PASSWORD" ssh -p $SSH_PORT $VM_USERNAME@localhost cat /sys/module/$KERNEL_MODULE_NAME/sections/.bss`


GDBINIT_PATH=$HOME_DIRECTORY/.gdbinit

if [ -f $GDBINIT_PATH.bak ]; then
    echo "[+] using an existing .gdbinit file"
    cp $GDBINIT_PATH.bak $GDBINIT_PATH
else
    echo "[+] creating a new .gdbinit file"
    rm -f $GDBINIT_PATH
    touch $GDBINIT_PATH
fi

section_flags=""
if [ -z "$data_address" ]; 
    then : # no data section
else
    section_flags+=" -s .data ${data_address}"
fi

if [ -z "$bss_address" ];
    then : # no bss section 
else
    section_flags+=" -s .bss ${bss_address}"
fi

echo "set disassembly-flavor intel" >> $GDBINIT_PATH
echo "file LINUX_SRC_PATH_PLACEHOLDER/vmlinux" >> $GDBINIT_PATH
echo "add-symbol-file $CWD/$KERNEL_MODULE_NAME.ko $text_address ${section_flags}" >> $GDBINIT_PATH
echo "break init_module" >> $GDBINIT_PATH