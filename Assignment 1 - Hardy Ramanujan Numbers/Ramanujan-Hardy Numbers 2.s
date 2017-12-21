mov r0,#25 @Numbers required to be found
mov r1,#0 @Numbers found so far
mov r2,#11 @'a'
loop_for_first:add r2,r2,#1
	mul r12,r2,r2
	mul r3,r12,r2 @'a^3' 
	mov r4,#0 @'b'
	loop_for_second:add r4,r4,#1
		cmp r4,r2
		beq loop_for_first
		mul r12,r4,r4
		mul r5,r12,r4 @'b^3'
		add r6,r5,r3 @'a^3+b^3'
		mov r7,r4 @'c'
		loop_for_third:add r7,r7,#1
			cmp r7,r2
			beq loop_for_second
			mul r12,r7,r7
			mul r8,r7,r12 @'c^3'
			cmp r8,r6
			bge loop_for_second
			mov r9,r4 @'d'
			loop_for_fourth:add r9,r9,#1
				cmp r9,r7
				beq loop_for_third
				mul r12,r9,r9
				mul r10,r9,r12 @ 'd^3'
				add r11,r10,r8 @'c^3+d^3'
				cmp r11,r6
				bgt loop_for_third
				blt loop_for_fourth	
				ldr r8,=4
				ldr r5,=0x1000
				mul r12,r1,r8
				str r6,[r12,r5]
				add r1,r1,#1
				cmp r0,r1
				beq L
				bne loop_for_fourth
L:swi 0x11