# Linux Kernel Development
In this tutorial we will setup an environment to build, develop and debug our kernel module.

We will use vscode as IDE and GDB + QEMU as debugger. This part is highly relies on the [previous part](https://github.com/Rhydon1337/linux-kernel-debugging)
which describes how to compile the kernel using buildroot and how to debug it.

## Requirements
When I was searching for an IDE, there were three guidelines in my mind:

1. GUI - I really like to program in a gui IDE. I searched for a gui IDE which can be easily configured and already has a community that supports it. In addition, it was important that it will have a variety of plugins.

2. Autocomplete - development is absolutely better and faster with autocomplete. But, if the autocomplete engine/indexer is slow we will lose all of the benefits. Also, it is very important that it could be easily configured.

3. Build system and debugging support - I think that compiling the kernel module from your IDE will make your development time shorter. In my opinion, if you really want to maximize your development setup, then debugging and testing automations are necessaries. 

### Why not Atom
Atom is really nice open source text editor but not an IDE. Atom autocompelete plugins are very poor, I did some searches in google and I find out that atom community support not so stable. I didnt even looked for a build system or debugging support.

### Why not Sublime
Sublime is excellent text editor and code browser, but it didnt suit to my requirements. Sublime has a lot of plugins and really nice autocomplete and symbols search engines. In addition, sublime is vert comfort for code browsing. However, sublime projects and build system is very poor and limited, sublime autocomplete plugins were fine but I didn't succeed to adjust them to kernel autocomplete.

### Why not Eclipse
Eclipse is very stable and known IDE, eclipse supports kernel browsing and autocomplete but eclipse C indexer is really slow.
Eclipse build system and debugging support known to everyone, I don't like eclipse GUI but it's a matter of teste. Eclipse was really close to my demands but its GUI not so modern and its autocomplete wasn't so good and really slow.

### Why Vscode
Vscode is very known and modern IDE, vscode autocomplete is configurable and fast. Vscode GUI is modern and rich and has a lot of plugins. Vscode comes with really good build system and debugging support (debugging plugins too).

I have choose vscode as my linux kernel development IDE. This project is coupled with vscode which says everyone that works with this environment will have to use vscode (which reminds me some of the reasons of the subject visual studio vs cmake).

## Environment setup

Before we start make sure you have everything that needed, if you already done the previous part make sure that you configured SSH too.

* Linux sources for your kernel version
* Compiled kernel image(bzImage) + rootfs
* Qemu vm with snapshot
* SSH to root configured

Install vscode, after the installtion complete download these packages:

* vscode-cpptools - supports for C/C++ to Vscode, including features such as IntelliSense and debugging
* hide-gitignored - hide files from the file Explorer that are ignored by your workspace's .gitignore files
* Native Debug - native VSCode debugger. Supports both GDB and LLDB

Clone the project and open vscode(on the project) and lets start to configure it.

### Autocomplete

1. Go to c_cpp_proprites.json
2. Replace "/home/rhydon/workspace/buildroot-2020.02.4/output/build/linux-4.19.91" with yours kernel dir path
3. Make sure that "/usr/lib/gcc/x86_64-linux-gnu/7/include" exists too otherwise change the version to yours it should works too
 
### Debugging

1. Sudo apt install sshpass
2. Go to debug.sh
3. Change VM_USERNAME, VM_PASSWORD and VM_SNAPSHOT to yours 
4. Change KERNEL_MODULE_NAME to yours kernel module name
5. Change BUILDROOT_IMAGES_PATH to the dir that contains the kernel(bzImage) and the rootfs(rootfs.qcow2 in builtroot)

If the debbuging is stuck or doesn't loading successfully try:

* sudo pkill -9 qemu
* sudo pkill -9 debug.sh
* sudo pkill -9 gdb

I left in debug.sh the .data and .bss sections commented. When your driver will use this sections undone the comments and remove the echo which using add-symbol-path only with the .text section.

Make sure that you change the kernel sources\include dir in the Makefile.

Now you can enjoy from a good linux kernel development session with autocomplete and debugging.


