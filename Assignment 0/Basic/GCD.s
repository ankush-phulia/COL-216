.equ SWI_Exit,0x11
Start: mov r0,#15 @a
	mov r1,#12 @b
	bl GCD

GCD: str lr,[sp,#-4]!
	str r0,[sp,#-4]!
	str r1,[sp,#-4]!
	cmp r1,#0 @b=0?
	beq Reta
	cmp r0,r1 @a>=b?
	bge Retg
	blt swap

Retg:ldr r1,[sp]
	ldr r0,[sp,#4]
	sub r0,r0,r1 @a-b
	bl GCD

swap:ldr r1,[sp]
	ldr r0,[sp,#4]
	mov r2,r0 @store a's value in temp
	mov r0,r1
	mov r1,r2
	bl GCD

Reta:ldr lr,[sp,#8]
	add sp,sp,#12
	swi SWI_Exit
	