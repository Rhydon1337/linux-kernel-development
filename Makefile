MODULENAME := <INSERT_MODULE_NAME>

obj-m += $(MODULENAME).o

$(MODULENAME)-y += src/<FILES>

ccflags-y := -O0 -Wno-declaration-after-statement -Wno-discarded-qualifiers

KERNELDIR ?= ~/workspace/buildroot/output/build/linux-4.19.98
# KERNELDIR ?= /lib/modules/4.10.0-38-generic/build
PWD       := $(shell pwd)

debug:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
release:
	$(MAKE) -C $(rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions debug) M=$(PWD) modules
install:
	sudo insmod $(MODULENAME).ko
remove:
	sudo rmmod $(MODULENAME).ko
clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions debug