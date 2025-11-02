data segment
    msg db 0dh,0ah,'$'
data ends

stack segment para stack
    db 64 dup(0)
stack ends

code segment
assume cs:code,ds:data

start:
    mov ax,data
    mov ds,ax

    mov bh,'a'
    mov cx,26
    mov bl,13

print_loop:
    mov dl,bh
    mov ah,02h
    int 21h

    mov dl,' '
    mov ah,02h
    int 21h
    
    inc bh
    dec bl
    jnz skip_line
    mov ah,09h
    lea dx,msg
    int 21h
    mov bl,13

skip_line:
    loop print_loop

    mov ah,4ch
    int 21h

code ends
end start