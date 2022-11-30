# Linux Kernel Development
In this tutorial we will setup an environment to build, develop and debug our kernel module.

We will use vscode as an IDE and GDB + QEMU as debugger. This part highly relies on the [previous part](https://github.com/Rhydon1337/linux-kernel-debugging)
which describes how to compile the kernel using buildroot and how to debug it.

## Requirements
When I was searching for an IDE, there were three guidelines in my mind:

1. GUI - I really like to program in a GUI based IDE. I've searched for a GUI based IDE which can be easily configured and already has a community that supports it. In addition, it was important that it will have a variety of plugins.

2. Autocompletion - development is absolutely better and faster with autocompletion. But, if the autocompletion engine/indexer is slow we will lose all of the benefits. Also, it is very important that it could be easily configured.

3. Build system and debugging support - I think that compiling the kernel module from your IDE will make your development time shorter. In my opinion, if you really want to maximize your development setup, then debugging and testing automations are necessities. 

### Why not Atom
Atom is a really nice open source text editor, but not a complete IDE. Atom autocompelete plugins are very poor, I did some searches in google and I've found out that atom community support is not so wide. and stable. I didn't even look for a build system or debugging support.

### Why not Sublime
Sublime is excellent text editor and code browser, but it didn't suit my requirements. Sublime has a lot of plugins and really nice autocompletion and symbols search engines. In addition, sublime is very comfortable for code browsing. However, sublime projects and build system are very poor and limited, sublime autocompletion plugins were fine but I wasn't able to adjust them to kernel autocompletion successfuly.

### Why not Eclipse
Eclipse is very stable and known IDE, Eclipse supports kernel browsing and autocompletion but Eclipse C indexer is really slow.
Eclipse build system and debugging support are known to everyone, Personally, I don't like eclipse GUI but it's a matter of teste. Eclipse came really close to my demands but its GUI is not so modern and its autocompletion wasn't so good and really slow.

### Why Vscode
Vscode is very known and modern IDE, vscode autocompletion is configurable and fast. Vscode GUI is modern and rich and has a lot of plugins. Vscode comes with really good build system and debugging support (debugging plugins too).

I have choose vscode as my linux kernel development IDE. This project is coupled with vscode which says everyone that works with this environment will have to use vscode (which reminds me some of the reasons of the subject visual studio vs cmake).

## Environment setup

Before we start make sure you have everything that needed, if you already done the previous part make sure that you configured SSH too.

* Linux sources for your kernel version
* Compiled kernel image(bzImage) + rootfs
* Qemu vm with snapshot
* SSH to root configured

Install vscode, after the installation is complete, download these packages:

* vscode-cpptools - supports for C/C++ to Vscode, including features such as IntelliSense and debugging
* hide-gitignored - hide files from the file Explorer that are ignored by your workspace's .gitignore files
* Native Debug - native VSCode debugger. Supports both GDB and LLDB

Clone the project and open vscode(on the project) and lets start configuring it.

## Project Configuration

1. sudo apt install sshpass
2. wget -O ~/.gdbinit-gef.py -q https://gef.blah.cat/py



### Autocompletion

1. Go to c_cpp_properties.json
2. Replace "/home/rhydon/workspace/buildroot-2020.02.4/output/build/linux-4.19.91" with yours kernel dir path
3. Replace "/usr/lib/gcc/x86_64-linux-gnu/7/include" with your gcc header files
 
### Debugging Fields


1. Go to debug.sh
2. Change VM_USERNAME, VM_PASSWORD and VM_SNAPSHOT to yours 
3. Change KERNEL_MODULE_NAME to yours kernel module name
4. Change BUILDROOT_IMAGES_PATH to the dir that contains the kernel(bzImage) and the rootfs(rootfs.qcow2 in buildroot)

Make sure to change the kernel sources\include dir in the Makefile.

> You can use `configure.py` to automate the configuration prcoess in the following manner:
>
>`python ./configure.py --linux-src /home/<user>/path/to/buildroot/output/build/linux-{version} 
>--gcc-include-path /usr/lib/gcc/x86_64-pc-linux-gnu/{gcc-version}/include --guest-root-password {qemu-vm-root-password}`


## Debugging
You can debug with vscode directly or use `gdb -x home/<user>/path/to/buildroot/output/images/.gdbinit` and run `target remote:1234` 



### Debugging lkm_init (The module's main function)
Setting a breakpoint at the start of the module's main function
is problematic. 

In order to stop in such breakpoint it needs to be set before
the module is inserted. GDB opposes this kind of behavior as
the memory region in that time is unreachable.

However, it can be done using symbols that exist regardless of
the module - kernel functions.

By adding a breakpoint to `_printk` for example you can stop
at the module's main function and place more breakpoints afterwards.

If the debbuging is stuck or isn't loading successfully try:

* sudo pkill -9 qemu
* sudo pkill -9 debug.sh
* sudo pkill -9 gdb


Now you can enjoy from a good linux kernel development session with autocompletion and debugging.


