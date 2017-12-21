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
loop_for_n:
	sub r0,r0,#1
	cmp r0,#0
	beq exit
	mov r1,#-1 @i
	loop_for_i:
		add r1,r1,#1
		cmp r1,r0
		bge loop_for_n
		add r2,r1,#1
		ldr r3,[r12,r1,LSL #2] @A[i]
		ldr r4,[r12,r2,LSL #2] @A[i+1]
		cmp r3,r4
		ble loop_for_i
		bge swap

swap:
	mov r5,r4
	mov r4,r3
	mov r3,r5
	str r3,[r12,r1,LSL #2]
	str r4,[r12,r2,LSL #2]
	b loop_for_i

exit:swi SWI_Exit

