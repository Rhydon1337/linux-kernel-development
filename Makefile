MODULENAME := kernel_development

obj-m += $(MODULENAME).o

$(MODULENAME)-y += main.o

KERNELDIR ?= /home/rhydon/workspace/buildroot-2020.02.4/output/build/linux-4.19.91

PWD       := $(shell pwd)

all: debug

release:
	$(MAKE) -C $(rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions debug) M=$(PWD) modules

ccflags-y := -g -Og -O0
debug:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions debug