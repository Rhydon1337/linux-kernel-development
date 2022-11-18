MODULENAME := KERNEL_MODULE_NAME_PLACEHOLDER

obj-m += $(MODULENAME).o

$(MODULENAME)-y += main.o

KERNELDIR ?= LINUX_SRC_PATH_PLACEHOLDER

PWD       := $(shell pwd)

all: debug

release:
	$(MAKE) -C $(rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions debug) M=$(PWD) modules

ccflags-y := -g -Og -O0
debug:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions debug