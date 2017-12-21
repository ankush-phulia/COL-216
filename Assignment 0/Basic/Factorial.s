.equ SWI_Exit,0x11
Start:mov r0,#20
mov r1,#1
ldr r4,=0x2000
bl fact

fact: str lr,[sp,#-4]!
    str r0,[sp,#-4]!
    cmp r0,#1
    bgt retf
    beq ret1

retf:ldr r0,[sp]
	mul r1,r0,r1
	sub r0,r0,#1
	bl fact

ret1:mov r0,#1
	ldr lr,[sp,#4]
	add sp,sp,#8
	swi SWI_Exit