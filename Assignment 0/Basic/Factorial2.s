.equ SWI_Exit, 0x11
_start:mov r0, #1
mov r1, #1
ldr r4, =0x2000
bl fact

fact:cmp r1, #0
beq ret1
mul r2, r0, r1
mov r0, r2
sub r1, r1, #1
str lr, [sp,#-4]!
str r0, [sp,#-4]!
str r1, [sp,#-4]!
bl fact

ret1:ldr r5, [sp,#4] 
str r5, [r4,#0]
ldr lr, [sp, #8]
add sp, sp, #12
swi SWI_Exit