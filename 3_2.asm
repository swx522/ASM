data segment
    result dw 0
    result_str db 6 dup(0)
data ends

stack segment para stack
    db 64 dup(0)
stack ends

code segment
assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax

    mov cx,100
    mov ax,0
    mov bx,1

sum_loop:
    add ax,bx
    inc bx
    loop sum_loop

    mov [result],ax

    mov ax,[result]
    mov bx,10
    mov si,offset result_str+5
    mov BYTE PTR [si],'$'
    dec si

convert_loop:
    xor dx,dx
    div bx
    add dl,'0'
    mov [si],dl
    dec si
    test ax,ax
    jnz convert_loop

    mov dx,si
    mov ah,09h
    int 21h

    mov ah,4ch
    int 21h

code ends
end start