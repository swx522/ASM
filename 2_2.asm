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

next_char:
    mov dl,bh
    mov ah,02h
    int 21h

    mov dl,' '
    mov ah,02h
    int 21h

    inc bh
    dec bl
    jnz not_line_end

    mov ah,09h
    lea dx,msg
    int 21h

    mov bl,13
    
not_line_end:
    dec cx
    jnz next_char

    mov ah,4ch
    int 21h
code ends
end start