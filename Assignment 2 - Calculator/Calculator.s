.equ SEG_A,0x80
.equ SEG_B,0x40
.equ SEG_C,0x20
.equ SEG_D,0x08
.equ SEG_E,0x04
.equ SEG_F,0x02
.equ SEG_G,0x01
.equ SEG_P,0x10

Error:
.ascii "Error detected"

Digits:
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
.word SEG_B|SEG_C @1
.word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
.word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3
.word SEG_G|SEG_F|SEG_B|SEG_C @4
.word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5
.word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6
.word SEG_A|SEG_B|SEG_C @7
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8
.word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9
.word 0 @Blank display

start:
	mov r4,#0 @number stack length
	mov r4,#0 @operator stack length
	mov r10,#0 @pointer to current Vi
	mov r11,#1 @operator=true?
	mov r9,#3 @current x position
	mov r6,#0 @number buffer
	mov r3,#1 @Error state
	mov r7,#0 @Negative flag
	swi 0x206 @ clear the screen
	mov r1,#0
	bl print
	mov r1,#1
	bl print
	mov r1,#2
	bl print
	mov r1,#3
	bl print
	mov r1,#4
	bl print
	mov r1,#5
	bl print
	mov r1,#6
	bl print
	mov r1,#7
	bl print
	mov r1,#8
	bl print
	mov r1,#9
	bl print
	ldr r12,=Digits
	ldr r0,[r12,r10,LSL#2]
	swi 0x200

b check_input

print:
	mov r0,#0
	ldr r12,=0x3000
	str r0,[r12,r1,lsl#2]
	ldr r12,=0x2000
	str r0,[r12,r1,lsl#2]
	mov r2,#'v'
	swi 0x207
	mov r0,#1
	mov r2,r1
	swi 0x205
	mov r0,#2
	mov r2,#'='
	swi 0x207
	mov pc,lr

check_input: @ which is constantly checking for input

	check_black: @ check if black button is pressed
		swi 0x202
		cmp r0,#0x01
		beq blk_rt @ If input is 1, goto handler of right black pressed
		cmp r0,#0x02
		beq blk_lt @ If input is 2, goto handler of left black pressed

	check_blue: @ check if blue button is pressed
		swi 0x203
		cmp r0,#1
		beq blu_0
		cmp r0,#2
		beq blu_1
		cmp r0,#4
		beq blu_2
		cmp r0,#8
		beq blu_3
		cmp r0,#16
		beq blu_4
		cmp r0,#32
		beq blu_5
		cmp r0,#64
		beq blu_6
		cmp r0,#128
		beq blu_7
		cmp r0,#256
		beq blu_8
		cmp r0,#512
		beq blu_9
		cmp r0,#1024
		beq blu_prev
		cmp r0,#2048
		beq blu_nxt
		cmp r0,#4096
		beq blu_plus
		cmp r0,#8192
		beq blu_min
		cmp r0,#16384
		beq blu_mul
		cmp r0,#32768
		beq blu_div

	bl check_input @loop back

blk_rt:
	mov r0,#0
	swi 0x201
	cmp r10,#9
	beq check_input
	add r10,r10,#1
	ldr r12,=Digits
	ldr r0,[r12,r10,LSL#2]
	swi 0x200
	b check_input

blk_lt:
	mov r0,#0
	swi 0x201
	cmp r10,#0
	beq check_input
	sub r10,r10,#1
	ldr r12,=Digits
	ldr r0,[r12,r10,LSL#2]
	swi 0x200
	b check_input

blu_0:
	mov r0,#0
	swi 0x201
	mov r2,#0
	bl display
	b check_input

blu_1:	
	mov r0,#0
	swi 0x201
	mov r2,#1
	bl display
	b check_input

blu_2:	
	mov r0,#0
	swi 0x201
	mov r2,#2
	bl display
	b check_input

blu_3:	
	mov r0,#0
	swi 0x201
	mov r2,#3
	bl display
	b check_input

blu_4:
	mov r0,#0
	swi 0x201
	mov r2,#4
	bl display
	b check_input

blu_5:
	mov r0,#0
	swi 0x201
	mov r2,#5
	bl display
	b check_input

blu_6:
	mov r0,#0
	swi 0x201
	mov r2,#6
	bl display
	b check_input

blu_7:	
	mov r0,#0
	swi 0x201
	mov r2,#7
	bl display
	b check_input

blu_8:
	mov r0,#0
	swi 0x201
	mov r2,#8
	bl display
	b check_input

blu_9:
	mov r0,#0
	swi 0x201
	mov r2,#9
	bl display
	b check_input

blu_plus:
	mov r0,#0
	swi 0x201
	mov r2,#'+'
	bl display
	b check_input

blu_min:
	mov r0,#0
	swi 0x201
	mov r2,#'-'
	bl display
	b check_input

blu_mul:
	mov r0,#0
	swi 0x201
	mov r2,#'.'
	bl display
	b check_input

blu_div:
	mov r0,#0
	swi 0x201
	mov r2,#'/'
	bl display
	b check_input

blu_nxt:
	mov r0,#0
	swi 0x201
	ldr r5,=0x4000
	cmp r7,#0
	beq poseq
	bne negq
	poseq:
		mov r7,#0
		str r6,[r5,r4,lsl#2]
		b normeq
	negq:
		mov r7,#0
		rsb r6,r6,#0
		str r6,[r5,r4,lsl#2]
		b normeq
	normeq:
	b eval	
	back:
	ldr r5,=0x4000
	ldr r2,[r5]
	ldr r12,=0x3000
	str r2,[r12,r10,lsl#2]

	mov r0,r10
	swi 0x208
	mov r9,#3
	mov r1,r10
	mov r0,#3
	cmp r2,#0
	bge posno
	mov r3,r2
	mov r2,#'-'
	swi 0x207
	mov r0,#4
	rsb r2,r3,#0
	posno:
	swi 0x205

	mov r0,#0
	mov r2,#'v'
	mov r1,r10
	swi 0x207
	mov r0,#1
	mov r2,r1
	swi 0x205
	mov r0,#2
	mov r2,#'='
	swi 0x207
	mov r0,#10
	swi 0x208
	mov r3,#0
	mov r6,#0
	mov r11,#1
	ldr r12,=0x2000
	str r11,[r12,r10,lsl#2]
	bl clr_stacks
	b check_input

blu_prev:
	ldr r12,=0x2000
	ldr r2,[r12,r10,lsl#2]
	cmp r2,#0
	beq err
	ldr r12,=0x3000
	ldr r2,[r12,r10,lsl#2]
	mov r1,#1
	mov r5,#0
	cmp r2,#0
	bge digs1
	blt digs2
	digs1:
		mov r12,#10
		add r5,r5,#1
		mul r0,r1,r12
		mov r1,r0
		cmp r2,r1
		bge digs1
		blt finp
	digs2:
		mov r12,#-10
		add r5,r5,#1
		mul r0,r1,r12
		mov r1,r0
		cmp r2,r1
		ble digs1
		bgt finn
	finp:
		mov r1,#10
		mov r0,r9
		swi 0x205
		add r9,r9,r5
		add r6,r6,r2
		b next
	finn:
		mov r1,#10
		mov r0,r9
		rsb r3,r2,#0
		mov r12,r3
		mov r2,#'-'
		swi 0x207
		bl display
		mov r0,r9
		mov r2,r12
		swi 0x205
		add r9,r9,r5
		add r6,r6,r2
		mov r3,#1
		b next
	err:
		ldr r0,=0x02
		swi 0x201
	next:
	mov r3,#1
	b check_input

light_left:
	mov r0,#0x02
	swi 0x201
	b check_input

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

clr_stacks:
	clr_nos:
		cmp r4,#0
		beq done
		ldr r0,=0x81818181
		sub r4,r4,#1
		str r0,[r5,r4,lsl#2]
		b clr_nos
	done:
		mov pc,lr

eval:
	add r4,r4,#1
	mov r8,#0
	mov r9,#0
	divloop:
		cmp r8,r4
		bge stopd1
		add r2,r8,#1
		ldr r5,=0x4000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'/'
		beq divn
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x5000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b divloop
	divn:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		bl div
		mov r2,r0
		ldr r5,=0x5000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b divloop
	stopd1:
		ldr r5,=0x4000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0
	divloop2:
		cmp r8,r4
		bge stopd2
		add r2,r8,#1
		ldr r5,=0x5000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'/'
		beq divn2
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x4000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b divloop2
	divn2:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		bl div
		mov r2,r0
		ldr r5,=0x4000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b divloop2
	stopd2:
		ldr r5,=0x5000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0

	mulloop:
		cmp r8,r4
		bge stopm1
		add r2,r8,#1
		ldr r5,=0x4000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'.'
		beq mult
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x5000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b mulloop
	mult:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		mul r2,r0,r1
		ldr r5,=0x5000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b mulloop
	stopm1:
		ldr r5,=0x4000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0
	mulloop2:
		cmp r8,r4
		bge stopm2
		add r2,r8,#1
		ldr r5,=0x5000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'.'
		beq mult2
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x4000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b mulloop2
	mult2:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		mul r2,r0,r1
		ldr r5,=0x4000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b mulloop2
	stopm2:
		ldr r5,=0x5000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0
	mulloop3:
		cmp r8,r4
		bge stopm3
		add r2,r8,#1
		ldr r5,=0x4000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'.'
		beq mult3
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x5000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b mulloop3
	mult3:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		mul r2,r0,r1
		ldr r5,=0x5000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b mulloop3
	stopm3:
		ldr r5,=0x4000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0
	mulloop4:
		cmp r8,r4
		bge stopm4
		add r2,r8,#1
		ldr r5,=0x5000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'.'
		beq mult2
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x4000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b mulloop4
	mult4:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		mul r2,r0,r1
		ldr r5,=0x4000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b mulloop4
	stopm4:
		ldr r5,=0x5000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0

	addloop1:
		cmp r8,r4
		bge stopa1
		add r2,r8,#1
		ldr r5,=0x4000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'+'
		beq addn1
		cmp r0,#'-'
		beq subn1
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x5000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b addloop1
	addn1:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		add r2,r0,r1
		ldr r5,=0x5000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b addloop1
	subn1:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		sub r2,r0,r1
		ldr r5,=0x5000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b addloop1
	stopa1:
		ldr r5,=0x4000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0
	addloop2:
		cmp r8,r4
		bge stopa2
		add r2,r8,#1
		ldr r5,=0x5000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'+'
		beq addn2
		cmp r0,#'-'
		beq subn2
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x4000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b addloop2
	addn2:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		add r2,r0,r1
		ldr r5,=0x4000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b addloop2
	subn2:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		sub r2,r0,r1
		ldr r5,=0x4000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b addloop2
	stopa2:
		ldr r5,=0x5000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0
	addloop3:
		cmp r8,r4
		bge stopa3
		add r2,r8,#1
		ldr r5,=0x4000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'+'
		beq addn3
		cmp r0,#'-'
		beq subn3
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x5000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b addloop3
	addn3:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		add r2,r0,r1
		ldr r5,=0x5000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b addloop3
	subn3:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		sub r2,r0,r1
		ldr r5,=0x5000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b addloop3
	stopa3:
		ldr r5,=0x4000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#0
	addloop4:
		cmp r8,r4
		bge stopa4
		add r2,r8,#1
		ldr r5,=0x5000
		ldr r0,[r5,r2,lsl#2]
		cmp r0,#'+'
		beq addn4
		cmp r0,#'-'
		beq subn4
		ldr r0,[r5,r8,lsl#2]
		ldr r5,=0x4000		
		str r0,[r5,r9,lsl#2]
		add r8,r8,#1
		add r9,r9,#1
		b addloop4
	addn4:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		add r2,r0,r1
		ldr r5,=0x4000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b addloop4
	subn4:
		ldr r0,[r5,r8,lsl#2]
		add r2,r2,#1
		ldr r1,[r5,r2,lsl#2]
		sub r2,r0,r1
		ldr r5,=0x4000
		str r2,[r5,r9,lsl#2]
		add r9,r9,#1
		add r8,r8,#3
		b addloop4
	stopa4:
		ldr r5,=0x5000
		bl clr_stacks
		add r4,r9,#1
		mov r8,#0
		mov r9,#3

	b back

div:
	stmfd sp!,{r2-r3,lr}
	mov r2,r1
	mov r3,#0
	DivLoop:
		cmp r2,r0
		addle r3,r3,#1
		addle r2,r2,r1
		ble DivLoop
	mov r0,r3
	ldmfd sp!,{r2-r3,pc}