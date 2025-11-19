.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'Please input a decimal number: $'
    MSG2 DB 0DH, 0AH, 'The hex result is: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; 打印输入提示
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H

    ; 读取十进制数，结果在 BX
    CALL READ_DEC

    ; 打印结果提示
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H

    ; 打印 BX 的十六进制
    CALL PRINT_HEX

    MOV AH, 4CH
    INT 21H
MAIN ENDP


READ_DEC PROC
    PUSH AX
    PUSH CX
    PUSH DX

    XOR BX, BX      ; BX = 0

READ_LOOP:
    MOV AH, 01H
    INT 21H
    CMP AL, 0DH
    JE DONE

    SUB AL, '0'
    MOV AH, 0       ; AX = 数字

    PUSH AX         ; 保存新数字
    MOV AX, BX      ; AX = 旧值
    MOV BX, 10
    MUL BX          ; AX = 旧值 * 10
    POP BX          ; BX = 新数字
    ADD AX, BX      ; AX = 旧值*10 + 新数字
    MOV BX, AX      ; BX = 新值

    JMP READ_LOOP

DONE:
    POP DX
    POP CX
    POP AX
    RET
READ_DEC ENDP


PRINT_HEX PROC
    PUSH AX
    PUSH BX
    PUSH CX

    ; 保存原始值
    MOV AX, BX      ; AX = 原始数值

    ; 打印高4位
    MOV BX, AX
    MOV CL, 4
    SHR BX, CL
    CALL PRINT_NIBBLE

    ; 打印低4位
    MOV BX, AX
    AND BX, 0FH
    CALL PRINT_NIBBLE

    POP CX
    POP BX
    POP AX
    RET
PRINT_HEX ENDP


PRINT_NIBBLE PROC
    PUSH AX
    PUSH DX

    CMP BX, 9
    JBE NUM
    ADD BX, 'A' - 10
    JMP DISPLAY
NUM:
    ADD BX, '0'
DISPLAY:
    MOV DL, BL
    MOV AH, 2
    INT 21H

    POP DX
    POP AX
    RET
PRINT_NIBBLE ENDP

END MAIN