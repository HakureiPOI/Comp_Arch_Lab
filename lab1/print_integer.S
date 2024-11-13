/**
 *  向标准输出打1个64位整数
 * */

.section .bss
//    .lcomm num, 8       // 存储64位整数
    .lcomm buffer, 21   // 20个数字 + 1个空字符 作为输出的缓冲区

.section .data
    newline: .byte 0xA      // 换行符

.section .text
    .globl _start

_start:
    // 初始化要打印的数字
    mov $1234567890123456789, %rax
//    mov %rax, num(%rip)

    // 将整数转换为字符串
//    mov num(%rip), %rax
    lea buffer+20(%rip), %rdi   // 将输出字符串的最后一个字符地址放入rdi存器
    movb $0, (%rdi)             // 给取后一个字符赋'\0'标志结束

convert_loop:                   // 将整数转换为字符串等待输出
    xor %rdx, %rdx
    mov $10, %rcx
    div %rcx                    // rdx = rax % 10, rax = rax / 10
    add $'0', %dl              // 计算对应的ascii码, rdx存器的低8位叫dl存器
    dec %rdi
    mov %dl, (%rdi)             // 结果写内存
    test %rax, %rax             // 测试rax是否为0
    jnz convert_loop

find_start:                     // 转换结束，跳过字符串前的所有0
    cmpb $'0', (%rdi)
    jne print_string
    inc %rdi
    jmp find_start

print_string:                   // 开始输出字符串
                                // 计算字符串长度
    lea buffer+20(%rip), %rax
    sub %rdi, %rax              // 计算存储的字节数
    mov %rax, %rdx              // 待输出的字节数放入rdx中

    // 系统调用号 (sys_write)
    mov $1, %rax                // syscall: sys_write
    // 文件描述符 (stdout)
    mov $1, %rdi                // file descriptor: stdout
    // 指向字符串的指针
    mov %rdi, %rsi              // correct pointer to buffer
    lea buffer(%rip), %rsi      // corrected: point to start of buffer
    // 要写入的字节数
    mov %rdx, %rdx
    // 执行系统调用
    syscall

    // 打印换行符
    mov $1, %rax               // syscall: sys_write
    mov $1, %rdi               // file descriptor: stdout
    lea newline(%rip), %rsi    // pointer to newline
    mov $1, %rdx               // number of bytes to write
    syscall

    // 退出程序
    mov $60, %rax              // syscall: sys_exit
    xor %rdi, %rdi             // exit status 0
    syscall
