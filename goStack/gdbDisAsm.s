(gdb) disassemble /m
Dump of assembler code for function main.caller:
7   func caller() {
=> 0x0000000000458360 <+0>:     mov    %fs:0xfffffffffffffff8,%rcx  # 不必关注
   0x0000000000458369 <+9>:     cmp    0x10(%rcx),%rsp              # 不必关注
   0x000000000045836d <+13>:    jbe    0x4583b0 <main.caller+80>    # 不必关注
   0x000000000045836f <+15>:    sub    $0x38,%rsp       # 划分0x38字节的栈空间
   0x0000000000458373 <+19>:    mov    %rbp,0x30(%rsp)  # 保存调用者main的rbp
   0x0000000000458378 <+24>:    lea    0x30(%rsp),%rbp  # 设置此函数栈的rbp

8       var a int64 = 1
   0x000000000045837d <+29>:    movq   $0x1,0x28(%rsp)  # 局部变量a入栈

9       var b int64 = 2
   0x0000000000458386 <+38>:    movq   $0x2,0x20(%rsp)  # 局部变量b入栈

10      callee(a, b)
   0x000000000045838f <+47>:    mov    0x28(%rsp),%rax  # 读取第一个参数到rax
   0x0000000000458394 <+52>:    mov    %rax,(%rsp)      # callee第一个参数入栈
   0x0000000000458398 <+56>:    movq   $0x2,0x8(%rsp)   # callee第二个参数入栈
   0x00000000004583a1 <+65>:    callq  0x4583c0 <main.callee> # 调用callee

11  }
   0x00000000004583a6 <+70>:    mov    0x30(%rsp),%rbp  # rbp还原为main的rbp
   0x00000000004583ab <+75>:    add    $0x38,%rsp       # rsp还原为main的rsp
   0x00000000004583af <+79>:    retq                    # 返回

End of assembler dump.



(gdb) s  # 单步调试进入的callee函数
main.callee (a=1, b=2, ~r2=824634073176, ~r3=0) at /root/study/test.go:13
13  func callee(a, b int64) (int64, int64) {

(gdb) disassemble /m
Dump of assembler code for function main.callee:
13  func callee(a, b int64) (int64, int64) {
=> 0x00000000004583c0 <+0>:     sub    $0x18,%rsp        # 划分0x18大小的栈
   0x00000000004583c4 <+4>:     mov    %rbp,0x10(%rsp)   # 保存调用者caller的rbp
   0x00000000004583c9 <+9>:     lea    0x10(%rsp),%rbp   # 设置此函数栈的rbp
   0x00000000004583ce <+14>:    movq   $0x0,0x30(%rsp)   # 初始化第一个返回值为0
   0x00000000004583d7 <+23>:    movq   $0x0,0x38(%rsp)   # 初始化第二个返回值为0

14      c := a + 5
   0x00000000004583e0 <+32>:    mov    0x20(%rsp),%rax   # 从内存中获取第一个参数值到rax
   0x00000000004583e5 <+37>:    add    $0x5,%rax         # rax+=5
   0x00000000004583e9 <+41>:    mov    %rax,0x8(%rsp)    # 局部变量c入栈

15      d := b * 4
   0x00000000004583ee <+46>:    mov    0x28(%rsp),%rax   # 从内存中获取第二个参数值到rax
   0x00000000004583f3 <+51>:    shl    $0x2,%rax         # rax*=2
   0x00000000004583f7 <+55>:    mov    %rax,(%rsp)       # 局部变量d入栈

16      return c, d
   0x00000000004583fb <+59>:    mov    0x8(%rsp),%rax    # 局部变量c的值存储到rax
   0x0000000000458400 <+64>:    mov    %rax,0x30(%rsp)   # 将c赋值给第一个返回值
   0x0000000000458405 <+69>:    mov    (%rsp),%rax       # 局部变量d的值存储到rax
   0x0000000000458409 <+73>:    mov    %rax,0x38(%rsp)   # 将d赋值给第二个返回值

17  }
   0x000000000045840e <+78>:    mov    0x10(%rsp),%rbp   # rbp还原为caller的rbp
   0x0000000000458413 <+83>:    add    $0x18,%rsp        # rsp还原为caller的rsp
   0x0000000000458417 <+87>:    retq                     # 返回

End of assembler dump.
