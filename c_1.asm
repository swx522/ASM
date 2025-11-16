.model small
.stack 100h

.data
    prompt    db 'Please input a 1-2 digit hex number: $'
    result    db 0dh, 0ah, 'The decimal result is: $'
    newline   db 0dh, 0ah, '$'
    err_msg   db 0dh, 0ah, 'Invalid input!$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; 显示提示
    mov dx, offset prompt
    mov ah, 09h
    int 21h

    ; 读取第一个字符
    mov ah, 01h
    int 21h
    mov bl, al      ; BL 存放第一个字符

    ; 检查是否为回车（只输入0的情况，但我们要求至少1位，所以直接判断）
    cmp bl, 0dh
    je invalid_input

    ; 转换第一个字符为数值
    call char_to_hex
    jc invalid_input    ; 如果进位标志CF=1，说明转换失败
    mov ch, al          ; CH = 第一个十六进制位的值

    ; 预读第二个字符
    mov ah, 01h
    int 21h
    mov bh, al          ; BH 存放第二个字符（可能是数字，也可能是回车）

    cmp bh, 0dh         ; 如果第二个字符是回车，说明只有一位
    je single_digit

    ; 否则，转换第二位
    mov al, bh
    call char_to_hex
    jc invalid_input
    mov cl, al          ; CL = 第二个十六进制位的值

    ; 计算最终结果: result = CH * 16 + CL
    mov al, ch
    push cx
    mov cl,4
    shl al,cl
    pop cx
    add al,cl
    jmp print_result

single_digit:
    ; 只有一位，结果就是 CH
    mov al, ch

print_result:
    ; 显示结果提示
    mov dx, offset result
    mov ah, 09h
    int 21h

    ; 调用子程序打印 AL 中的十进制数
    call print_dec

    ; 换行并退出
    mov dx, offset newline
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21h

invalid_input:
    mov dx, offset err_msg
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21h

main endp


; 子程序: char_to_hex
; 功能: 将 AL 中的 ASCII 字符 ('0'-'9', 'A'-'F', 'a'-'f') 转换为对应的数值 (0-15)
; 输入: AL = ASCII 字符
; 输出: AL = 数值 (0-15)，如果失败则 CF=1
; 修改: AL
char_to_hex proc
    push bx
    mov bl, al

    ; 检查 '0' - '9'
    cmp bl, '0'
    jl invalid_char
    cmp bl, '9'
    jle is_digit

    ; 检查 'A' - 'F'
    cmp bl, 'A'
    jl invalid_char
    cmp bl, 'F'
    jle is_upper

    ; 检查 'a' - 'f'
    cmp bl, 'a'
    jl invalid_char
    cmp bl, 'f'
    jg invalid_char

    ; 如果是 'a'-'f'
    sub bl, 'a' - 10
    jmp valid_done

is_upper:
    sub bl, 'A' - 10
    jmp valid_done

is_digit:
    sub bl, '0'
    jmp valid_done

invalid_char:
    stc                 ; 设置进位标志 CF=1，表示错误
    jmp done

valid_done:
    clc                 ; 清除进位标志 CF=0，表示成功
done:
    mov al, bl
    pop bx
    ret
char_to_hex endp


; 子程序: print_dec
; 功能: 打印 AL 中的 8 位无符号十进制数 (0-255)
; 输入: AL = 要打印的数字
; 修改: AX, BX, CX, DX
print_dec proc
    push ax
    push bx
    push cx
    push dx

    ; 处理特殊情况：数值为0
    cmp al, 0
    jne not_zero
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp print_done

not_zero:
    ; 清零 AH，并将 AL 扩展到 AX
    mov ah, 0
    ; 使用栈来逆序存储数字
    mov bx, 10          ; 除数
    mov cx, 0           ; 数字位数计数器

divide_loop:
    xor dx, dx          ; DX = 0
    div bx              ; AX = AX / 10, DX = AX % 10
    push dx             ; 余数入栈
    inc cx
    cmp ax, 0
    jne divide_loop

print_loop:
    pop dx              ; 从栈中弹出余数
    add dl, '0'         ; 转换为 ASCII
    mov ah, 02h
    int 21h
    loop print_loop

print_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_dec endp

end main