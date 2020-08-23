# Linux Kernel Development
In this tutorial we will setup an environment to build, develop and debug our kernel module.

We will use vscode as IDE and GDB + QEMU as debugger. This part is highly relies on the previous part
which describes how to compile the kerel using buildroot and how to debug it.

## Why vscode
When I searched for a nice IDE I keept in mind two guidlines.

1. GUI - I really like to program in a gui IDE rather than a cli. I searched for a gui IDE which can be easily configured and already has a community that supports it. In addition, it was important that it will have a variety of plugins.

2. Autocomplete - development is absolutely better and faster with autocomplete. But, if the autocomplete engine/indexer is slow we will lose all of the benefits of autocomplete. Also, it is very important that it could be easily configured.

3. Build system and debugging support - I think that compiling the kernel module from your IDE will make your development time shorter. In my opinion, if you really want to maximize your development setup debugging and testing automations are necessaries. 

### Why not Atom
Atom is really nice open source Text editor but not an IDE. Atom autocompelete plugins are very poor, I did some google searches and I find out that atom community support not so stable. I didnt even looked for build system or debugging support.

### Why not 

Before we start make sure you have everything that needed, if you already done the previous part make sure that you configured SSH too.

1. Linux sources for your kernel version
2. Compiled kernel image (bzImage) + rootfs
3. Qemu vm with snapshot
4. SSH to root configured

