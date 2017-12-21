@ loop: which is constantly checking for input
b1:
	swi 0x202
	cmp r0,#0x01
	beq b2 @ If input is 1, goto handler of right black pressed
	cmp r0,#0x02
	beq b3 @ If input is 2, goto handler of left black pressed
	bl b1 @ keep checking constantly
	cmp r0,#1


@ handler of right black pressed
right pressed:
	mov r0,#0x01
	swi 0x201 @ light the right red bulb
	bl b1 @ move back to the loop b1

@ handler of left black pressed
b3:
	mov r0,#0x02
	swi 0x201 @ light the left red bulb
	bl b1 @ move back to the loop b1

@ Similarly add handlers for each type of button press

b eval1
			eval1:
				mov r4,#100
				ldr r5,=0x5000
				cmp r8,#0
				beq bp1
				sub r8,r8,#1
				ldr r12,[r5,r8,lsl#2] @prev operator
				cmp r12,r2 
				ble brk1
				bgt redo1
				brk1:
					add r8,r8,#1
					b bp1
				redo1:
					ldr r5,=0x4000
					add r4,r4,#100
					sub r4,r4,#1
					ldr r0,[r5,r4,lsl#2]
					str r1,[r5,r4,lsl#2]
					sub r4,r4,#1
					ldr r1,[r5,r4,lsl#2]
					cmp r12,#47
					beq divn1
					cmp r12,#46
					beq prodn1
					bne brk1
				divn1:
					b eval1
				prodn1:
					mul r12,r1,r0
					mov r0,r12
					ldr r5,=0x4000
					str r0,[r5,r4,lsl#2]
					b eval1
			bp1:
b eval2
			eval2:
			ldr r5,=0x5000
			cmp r8,#0
			beq bp2
			sub r8,r8,#1
			ldr r12,[r5,r8,lsl#2] @prev operator
			cmp r12,r2 
			ble brk2
			bgt redo2
			brk2:
				add r8,r8,#1
				b bp2
			redo2:
				ldr r5,=0x4000
				sub r4,r4,#1
				ldr r0,[r5,r4,lsl#2]
				sub r4,r4,#1
				ldr r1,[r5,r4,lsl#2]
				cmp r12,#'/'
				beq brk2
				bne divn2
			divn2:
				cmp r2,#'/'
				beq brk2
				@mul r12,r1,r0
				@ldr r5,=0x4000
				@str r12,[r4,r4,lsl#2]
				b eval2
			bp2:

divloop:
		add r8,r8,#1
		cmp r8,r4
		beq stop
		add r2,r8,#1
		ldr r5,=0x4000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'/' 
		beq divn
		ldr r5,=0x5000
		str r0,[r5,r8,lsl#2]
		b divloop
	stop:
	divloop3:
		cmp r8,r4
		bge stopd3
		add r2,r8,#1
		ldr r5,=0x4000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'.'
		beq divn3
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x5000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b divloop3
	divn3:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		mul r2,r0,r1
		ldr r5,=0x5000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b divloop3
	stopd3:
		ldr r5,=0x4000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0
	divloop4:
		cmp r8,r4
		bge stopd4
		add r2,r8,#1
		ldr r5,=0x5000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'.'
		beq divn2
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x4000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b divloop4
	divn4:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		mul r2,r0,r1
		ldr r5,=0x4000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b divloop4
	stopd4:
		ldr r5,=0x5000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0