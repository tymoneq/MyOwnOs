BUILD_DIR ?= build/
ASM ?= nasm
ASMFLAGS ?= -f elf32
CC16 ?= gcc
CFLAGS16 ?= -m16 -ffreestanding -nostdlib -O2 -Wall -Wextra
LD16 ?= ld

SOURCES_C = $(wildcard *.c)
SOURCES_ASM = $(wildcard *.asm)
OBJECTS_C = $(patsubst %.c, $(BUILD_DIR)/stage2/c/%.o, $(SOURCES_C))
OBJECTS_ASM = $(patsubst %.asm, $(BUILD_DIR)/stage2/asm/%.o, $(SOURCES_ASM))

.PHONY: all stage2 clean always

all: stage2

stage2: $(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage2.bin: $(OBJECTS_ASM) $(OBJECTS_C) always
	$(LD16) -m elf_i386 -T $(dir $(lastword $(MAKEFILE_LIST)))linker.ld \
		-o $(BUILD_DIR)/stage2.elf $(OBJECTS_ASM) $(OBJECTS_C)
	objcopy -O binary $(BUILD_DIR)/stage2.elf $@

$(BUILD_DIR)/stage2/c/%.o: %.c always
	$(CC16) $(CFLAGS16) -c -o $@ $< 

$(BUILD_DIR)/stage2/asm/%.o: %.asm always
	$(ASM) $(ASMFLAGS) -o $@ $<

always:
	mkdir -p $(BUILD_DIR)/stage2/c
	mkdir -p $(BUILD_DIR)/stage2/asm

clean:
	rm -f $(BUILD_DIR)/stage2.bin
	rm -rf $(BUILD_DIR)/stage2/