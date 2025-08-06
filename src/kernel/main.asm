org 0x0
bits 16

%define ENDL 0x0D, 0x0A



start:

    mov ax, 0x2000
    mov ds, ax
    mov es, ax

; print message
    mov si, msg_hello
    call puts


    jmp .halt
; Prints a string to the screen
; Params:
;  - ds:si points to the string
; 

.halt:
    cli
    hlt
    jmp .halt
    
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb 
    or al, al
    jz .done

    mov ah, 0x0e
    mov bh,0
    int 0x10


    jmp .loop

.done:
    pop ax
    pop si
    ret


msg_hello: db 'Kernel loaded successfully!', ENDL, 0

