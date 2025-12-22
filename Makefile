MODULE_NAME := hello
SRC_DIR := src
BUILD_DIR := build

all:
	@echo "Building module $(MODULE_NAME)..."
	@mkdir -p $(BUILD_DIR)
	@# Copy source file to build directory
	cp $(SRC_DIR)/$(MODULE_NAME).c $(BUILD_DIR)/
	@# Create Makefile in build directory
	@echo "obj-m := $(MODULE_NAME).o" > $(BUILD_DIR)/Makefile
	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(abspath $(BUILD_DIR)) modules
	@echo "Build complete. Module is in $(BUILD_DIR)/"

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
