[bits 16]
section .text

global x86_Video_WriteCharTeletype
x86_Video_WriteCharTeletype:
    push bp
    mov  bp, sp
    push bx

    mov  ah, 0x0E
    mov  al, [bp+6]   ; try second possible location
    int  0x10

    pop  bx
    mov  sp, bp
    pop  bp
    ret