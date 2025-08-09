ASM = nasm
CC = gcc
CC16 = gcc
LD16 = ld


SRC_DIR = src
BUILD_DIR = build
TOOLS_DIR = tools

.PHONY: all floppy_image kernel bootloader clean run tools_fat

# Default target
all: floppy_image tools_fat

# Create the build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

#
# Bootloader
#
bootloader: stage1 stage2


stage1:	$(BUILD_DIR)/stage1.bin

$(BUILD_DIR)/stage1.bin: always
	$(MAKE) -C $(SRC_DIR)/bootloader/stage1 BUILD_DIR=$(abspath $(BUILD_DIR))

stage2:	$(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage2.bin: always
	$(MAKE) -C $(SRC_DIR)/bootloader/stage2 BUILD_DIR=$(abspath $(BUILD_DIR))



#
# Kernel
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(MAKE) -C $(SRC_DIR)/kernel BUILD_DIR=$(abspath $(BUILD_DIR))

#
# Tools 
#
tools_fat: $(BUILD_DIR)/tools/fat

$(BUILD_DIR)/tools/fat: $(TOOLS_DIR)/fat/fat.c | $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/tools
	$(CC) -g -o $(BUILD_DIR)/tools/fat $(TOOLS_DIR)/fat/fat.c


#Always
always:
	mkdir -p $(BUILD_DIR)


#
# Floppy image
#
floppy_image: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_floppy.img
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/stage2.bin "::stage2.bin"
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
	mcopy -i $(BUILD_DIR)/main_floppy.img test.txt "::test.txt"
	dd if=$(BUILD_DIR)/stage1.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc bs=512 count=1

# Clean target
clean:
	rm -rf $(BUILD_DIR)

# Run in qemu (optional)
run: $(BUILD_DIR)/main_floppy.img
	qemu-system-i386 -fda $(BUILD_DIR)/main_floppy.img