.equ SWI_Exit,0x11

Coe:ldr r12,=0x1000
	mov r11,#4
	str r11,[r12],#4
	mov r11,#3
	str r11,[r12],#4
	mov r11,#2
	str r11,[r12],#4
	mov r11,#1
	str r11,[r12],#4
	ldr r12,=0x1000 @Intial Address of List

mov r0,#4 @list length
mov r1,#-1 @Pointer
increment_pointer:add r1,r1,#1
	cmp r1,r0
	beq exit
	mov r4,#1000 @Min value
	mov r5,#0 @Min Index
	sub r6,r1,#1 @i
	loop_for_minval:
		add r6,r6,#1
		cmp r6,r0
		bge swap
		ldr r7,[r12,r6,LSL #2] @A[i]
		cmp r7,r4
		bge loop_for_minval
		mov r4,r7
		mov r5,r6
		b loop_for_minval

swap:
	ldr r2,[r12,r1,LSL #2]
	str r4,[r12,r1,LSL #2]
	str r2,[r12,r5,LSL #2]

	b increment_pointer

exit:swi SWI_Exit