.equ SWI_Exit,0x11

Coe:ldr r12,=0x1000
	mov r11,#1
	str r11,[r12],#4
	mov r11,#1
	str r11,[r12],#4
	mov r11,#1
	str r11,[r12],#4
	ldr r12,=0x1000

Start:mov r0,#3 @n
	mov r1,#0 @a
	mov r2,#2 @x
	bl poly

poly:str lr,[sp,#-4]!
	str r0,[sp,#-4]!
	str r1,[sp,#-4]!
	cmp r0,#0
	beq Reta
	bne Retp

Retp:ldr r1,[sp]
	ldr r0,[sp,#4]
	sub r0,r0,#1
	ldr r4,[r12,r0,LSL #2]
	mul r5,r1,r2
	mov r1,r5
	add r1,r1,r4
	bl poly

Reta:
	ldr lr,[sp,#8]
	add sp,sp,#12
	swi SWI_Exit
