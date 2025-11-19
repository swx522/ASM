data segment
    newline db 0dh, 0ah, '$'    ; 回车换行
    space db ' $'               ; 空格
    equal db '=$'               ; 等号
    buffer db 3 dup(?)          ; 缓冲区用于数字转换
data ends

stack segment para stack
    db 64 dup(0)
stack ends

code segment
    assume cs:code, ds:data

start:
    mov ax, data
    mov ds, ax
    
    mov cx, 1                   ; 外层循环计数器 (i从1到9)
    
outer_loop:
    mov dx, 1                   ; 内层循环计数器 (j从1到i)
    
inner_loop:
    ; 保存寄存器
    push cx
    push dx
    
    ; 打印第一个数 (j)
    mov ax, dx
    call print_number
    
    ; 打印乘号
    mov dl, '*'
    mov ah, 02h
    int 21h
    
    ; 打印第二个数 (i)
    mov ax, cx
    call print_number
    
    ; 打印等号
    mov dx, offset equal
    mov ah, 09h
    int 21h
    
    ; 计算乘积 j * i
    pop dx                      ; 恢复j值
    push dx                     ; 再次保存
    mov ax, dx                  ; ax = j
    mul cx                      ; ax = j * i
    
    ; 打印乘积
    call print_number
    
    ; 打印空格分隔
    mov dx, offset space
    mov ah, 09h
    int 21h
    
    ; 恢复寄存器
    pop dx
    pop cx
    
    ; 内层循环控制：j从1递增到i
    inc dx
    cmp dx, cx
    jle inner_loop
    
    ; 换行
    mov dx, offset newline
    mov ah, 09h
    int 21h
    
    ; 外层循环控制：i从1递增到9
    inc cx
    cmp cx, 9
    jle outer_loop
    
    ; 程序结束
    mov ah, 4ch
    int 21h

; 子程序：打印AX中的数字
print_number proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    ; 将数字转换为字符串
    mov si, offset buffer
    mov bx, 10
    xor cx, cx
    
    ; 处理AX=0的情况
    test ax, ax
    jnz convert_loop
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp print_end
    
convert_loop:
    xor dx, dx
    div bx                      ; ax/10, dx=余数
    add dl, '0'                 ; 转换为ASCII
    push dx                     ; 压入堆栈
    inc cx
    test ax, ax
    jnz convert_loop
    
    ; 从堆栈弹出并打印
print_digit:
    pop dx
    mov ah, 02h
    int 21h
    loop print_digit
    
print_end:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number endp

code ends
end start