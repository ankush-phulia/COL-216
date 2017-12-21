.global clr_stacks

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