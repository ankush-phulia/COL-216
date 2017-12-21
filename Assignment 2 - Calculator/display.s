.global display

display:
	cmp r3,#0
	beq clr
	bne norm
	clr:mov r0,#10
		swi 0x208
	norm:
	cmp r2,#'+'
	beq operator1
	cmp r2,#'-'
	beq operator1
	cmp r2,#'.'
	beq operator2
	cmp r2,#'/'
	beq operator2
	bne integer
	operator1:
		mov r1,#10
		mov r0,r9
		swi 0x207
		add r9,r9,#1
		cmp r11,#0
		beq no1
		bne op1
		no1:
			ldr r5,=0x4000
			cmp r7,#0
			beq pos2
			bne neg2
			pos1:
				mov r7,#0
				str r6,[r5,r4,lsl#2]
				b norm1
			neg1:
				mov r7,#0
				rsb r6,r6,#0
				str r6,[r5,r4,lsl#2]
				b norm1
			norm1:
			add r4,r4,#1
			ldr r5,=0x4000
			str r2,[r5,r4,lsl#2]
			add r4,r4,#1
			mov r11,#1
			mov r6,#0
			mov r3,#1
			b end
		op1: 
			cmp r2,#'-'
			bne opp
			beq opm
			opp:
				mov r7,#0
				mov r11,#1
				mov r3,#1
				b end
			opm:
				mov r7,#1
				mov r11,#1
				mov r3,#1
				b end
	operator2:
		mov r1,#10
		mov r0,r9
		swi 0x207
		cmp r11,#0
		add r9,r9,#1
		beq no2
		bne op2
		no2:
			ldr r5,=0x4000
			cmp r7,#0
			beq pos2
			bne neg2
			pos2:
				mov r7,#0
				str r6,[r5,r4,lsl#2]
				b norm2
			neg2:
				mov r7,#0
				rsb r6,r6,#0
				str r6,[r5,r4,lsl#2]
				b norm2
			norm2:
			add r4,r4,#1
			
			ldr r5,=0x4000
			str r2,[r5,r4,lsl#2]
			add r4,r4,#1
			mov r11,#1
			mov r6,#0
			mov r3,#1
			b end
		op2: 
			mov r7,#0
			mov r0,#10
			swi 0x208
			mov	r9,#0
			mov r1,#10
			ldr r2,=Error
			mov r3,#0
			swi 0x204
			mov r11,#1
			ldr r5,=0x4000
			b clr_stacks
	integer:
		mul r5,r6,r1
		add r5,r5,r2
		mov r6,r5
		mov r0,r9
		mov r1,#10
		swi 0x205
		add r9,r9,#1
		mov r11,#0
		mov r3,#1
		b end
	end: mov pc,lr