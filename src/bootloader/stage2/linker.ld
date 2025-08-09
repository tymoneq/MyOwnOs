OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)

SECTIONS
{
  . = 0x0000;

  .text : { KEEP(*(.entry)) *(.text*) *(.rodata*) }
  .data : { *(.data*) }
  .bss  : { *(.bss*) *(COMMON) }
}
