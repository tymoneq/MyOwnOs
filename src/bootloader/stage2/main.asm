[bits 16]
section .text

extern cstart_
global _start

_start:
    cli
    
    ; Simple setup
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7000
    sti
    
    ; Just call C with no parameters for now
    call cstart_

.hang:
    cli
    hlt
    jmp .hang