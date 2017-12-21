mov r0,#18
mov r1,#3
bl div 
end: swi 0x11

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