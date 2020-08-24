# Linux Kernel Development
In this tutorial we will setup an environment to build, develop and debug our kernel module.

We will use vscode as IDE and GDB + QEMU as debugger. This part is highly relies on the previous part
which describes how to compile the kerel using buildroot and how to debug it.

## Requirements
When I was searching for an IDE, there were three guidelines in my mind:

1. GUI - I really like to program in a gui IDE rather than a cli. I searched for a gui IDE which can be easily configured and already has a community that supports it. In addition, it was important that it will have a variety of plugins.

2. Autocomplete - development is absolutely better and faster with autocomplete. But, if the autocomplete engine/indexer is slow we will lose all of the benefits of autocomplete. Also, it is very important that it could be easily configured.

3. Build system and debugging support - I think that compiling the kernel module from your IDE will make your development time shorter. In my opinion, if you really want to maximize your development setup debugging and testing automations are necessaries. 

### Why not Atom
Atom is really nice open source Text editor but not an IDE. Atom autocompelete plugins are very poor, I did some searches in google and I find out that atom community support not so stable. I didnt even looked for build system or debugging support.

### Why not Sublime
Sublime is text editor and even code browser, but it didnt suit to my requirements. Sublime has a lot of plugins and really nice autocomplete and symbols search engines. In addition, sublime is comfort for code browsing. However, sublime projects and build system is very poor and limited, sublime autocomplete plugins were fine but I didn't succeed to adjust them to kernel autocomplete.

### Why not Eclipse
Eclipse is very stable and known IDE, eclipse supports kernel browsing and autocomplete but eclipse C indexer is really slow.
Eclipse build system and debugging support known to everyone, I don't like eclipse GUI but it's a matter of teste. Eclipse was really close to my demands but its GUI not so modern and its autocomplete wasn't so good and really slow.

### Why Vscode
Vscode is very known and modern IDE, vscode autocomplete is configurable and fast. Vscode GUI is modern and rich and has a lot of plugins. Vscode comes with really good build system and debugging support (debugging plugins too).

I have choose vscode as my linux kernel development IDE. This project is coupled with vscode which says everyone that works with this environment will have to use Vscode (which reminds the subject of visual studio vs cmake).

## Environment setup

Before we start make sure you have everything that needed, if you already done the previous part make sure that you configured SSH too.

1. Linux sources for your kernel version
2. Compiled kernel image (bzImage) + rootfs
3. Qemu vm with snapshot
4. SSH to root configured

