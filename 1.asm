data segment
    msg db 'Hello,world!$'
data ends

stack segment para stack
    db 64 dup(0)
stack ends

code segment
assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax

    mov ah,09h
    mov dx,offset msg
    int 21h

    mov ah,4ch
    int 21h

code ends
end start