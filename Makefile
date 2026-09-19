USER  := $(shell whoami)
KVER ?= $(shell uname -r)
KDIR ?= /lib/modules/$(KVER)/build

all: build

build:
	$(MAKE) -C $(KDIR) M=$(PWD) LLVM=1 modules

install:
	$(MAKE) -C $(KDIR) M=$(PWD) LLVM=1 INSTALL_MOD_PATH=$(INSTALL_MOD_PATH) modules_install

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) LLVM=1 clean

load: all
	grep -q '^vendor_reset' /proc/modules && sudo rmmod vendor_reset || true
	sudo insmod ./vendor-reset.ko $(if $(NOHOOK),install_hook=no,)

.PHONY: userspace load all install
