// 定义格式字符串 "%s "，用于 printf 输出
.LC0:
    .string "%s "

main:
    push    rbp                 // 保存调用者基址指针（rbp）
    mov     rbp, rsp            // 设置当前函数的栈帧基址为当前栈顶
    sub     rsp, 16             // 为局部变量分配 16 字节栈空间

    mov     DWORD PTR [rbp-4], 0   // 初始化循环计数器 i = 0（存储在 [rbp-4]）
    mov     BYTE PTR [rbp-5], 97   // 初始化字符变量 c = 'a'（ASCII 97，存储在 [rbp-5]）
    jmp     .L2                  // 跳转到循环条件判断处

.L3:                            // 循环体开始
    movsx   eax, BYTE PTR [rbp-5]  // 将字符 c 符号扩展为 int 存入 eax（用于 printf 参数）
    mov     esi, eax               // 将字符值传给 esi（printf 第二个参数）
    mov     edi, OFFSET FLAT:.LC0  // 将格式字符串地址传给 edi（printf 第一个参数）
    mov     eax, 0                 // 清零 eax（表示无浮点参数传递）
    call    printf                 // 调用 printf("%s ", c)
    add     DWORD PTR [rbp-4], 1   // i++
    movzx   eax, BYTE PTR [rbp-5]  // 将字符 c 零扩展为 int 存入 eax
    add     eax, 1                 // c++
    mov     BYTE PTR [rbp-5], al   // 将更新后的字符存回 [rbp-5]
    jmp     .L2                    // 跳回循环条件判断

.L2:                            // 循环条件判断
    cmp     DWORD PTR [rbp-4], 26  // 比较 i 是否 <= 25（即是否小于 26）
    jle     .L3                  // 如果 i <= 25，则跳转到 .L3 继续循环
    mov     eax, 0               // 返回值设为 0（main 函数返回 0）
    leave                        // 恢复调用者栈帧（等价于 mov rsp, rbp// pop rbp）
    ret                          // 返回调用者