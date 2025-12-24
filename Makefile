MODULE_NAME := hello
SRC_DIR := src
BUILD_DIR := build

all: setup
	@echo "Building module $(MODULE_NAME)..."

	$(MAKE) -C /lib/modules/$(shell uname -r)/build \
	         M=$(abspath $(BUILD_DIR)) modules

	@echo "Build complete. Module is in $(BUILD_DIR) directory"

setup:
	@mkdir -p $(BUILD_DIR)
	@# Create symlink to source file
	@if [ ! -L $(BUILD_DIR)/$(MODULE_NAME).c ] || \
	   [ "$$(readlink -f $(BUILD_DIR)/$(MODULE_NAME).c 2>/dev/null)" \
		!= "$$(readlink -f $(SRC_DIR)/$(MODULE_NAME).c 2>/dev/null)" ]; \
		then \
		    ln -sf ../$(SRC_DIR)/$(MODULE_NAME).c $(BUILD_DIR)/$(MODULE_NAME).c; \
	fi
	@# Create symlink to Makefile.kernel
	@if [ ! -L $(BUILD_DIR)/Makefile ] || \
	   [ "$$(readlink -f $(BUILD_DIR)/Makefile 2>/dev/null)" \
		!= "$$(readlink -f Makefile.kernel 2>/dev/null)" ]; \
		then \
		    ln -sf ../Makefile.kernel $(BUILD_DIR)/Makefile; \
	fi


clean:
	@if [ -d "$(BUILD_DIR)" ]; then \
		$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(abspath $(BUILD_DIR)) clean; \
	fi

distclean: clean
	rm -rf $(BUILD_DIR)

# Helper targets for development
install: all
	sudo insmod $(BUILD_DIR)/$(MODULE_NAME).ko
	@echo "Module has been installed"

remove:
	sudo rmmod $(MODULE_NAME) || true

status:
	@lsmod | grep $(MODULE_NAME) || echo "Module '$(MODULE_NAME)' not loaded"

log:
	sudo dmesg | tail -20


.PHONY: all clean distclean install remove status log
