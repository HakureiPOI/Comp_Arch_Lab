/**
 *  向标准输出打印1个64位整数
 */

.section .bss
    .lcomm buffer, 21   // 20个数字 + 1个空字符 作为输出的缓冲区

.section .data
    newline: .byte 0xA      // 换行符

.section .text
    .globl _start

_start:
    // 初始化要打印的数字
    mov $1234567890123456789, %rax

    // 将整数转换为字符串
    lea buffer+20(%rip), %rdi   // 将输出字符串的最后一个字符地址放入rdi寄存器
    movb $0, (%rdi)             // 给最后一个字符赋'\0'标志结束

convert_loop:                   // 将整数转换为字符串等待输出
    xor %rdx, %rdx              // 清空rdx寄存器
    mov $10, %rcx
    div %rcx                    // rdx = rax % 10, rax = rax / 10
    add $'0', %dl               // 计算对应的ascii码, rdx寄存器的低8位叫dl寄存器
    dec %rdi
    mov %dl, (%rdi)             // 结果写入内存
                                // 判断是否结束
    test %rax, %rax             // 检查rax是否为0
    jnz convert_loop

print_string:                   // 开始输出字符串
                                // 计算字符串长度
    lea buffer+20(%rip), %rax
    sub %rdi, %rax              // 计算存储的字节数
    mov %rax, %rdx              // 待输出的字节数放入rdx中

    // 系统调用号 (sys_write)
    mov $1, %rax                // 系统调用号 1 (sys_write)
    // 文件描述符 (stdout)
    mov $1, %rdi
    // 指向字符串的指针
    mov %rsi, %rdi              // 将地址保存到 rsi
    mov %rsi, %r
