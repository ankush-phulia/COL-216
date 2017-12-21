.equ SWI_Exit,0x11
Start:mov r0,#5 @n
mov r1,#1 @a
mov r2,#2 @b
mov r4,#1 @result
ldr r4,=0x1000
bl fib

fib:str lr,[sp,#-4]!
str r0,[sp,#-4]!
str r1, [sp,#-4]!
str r2, [sp,#-4]!
cmp r0,#1
beq Reta
bgt Retf

Retf:ldr r2,[sp]
ldr r1,[sp,#4]
ldr r0,[sp,#8]
sub r0,r0,#1
mov r3,r2
add r2,r2,r1
mov r1,r3
bl fib

Reta:ldr r4,[sp,#4]
ldr lr, [sp, #12]
add sp, sp, #16
swi SWI_Exit