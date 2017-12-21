.global print

print:
	mov r0,#0
	ldr r12,=0x30000
	str r0,[r12,r1,lsl#2]
	ldr r12,=0x20000
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