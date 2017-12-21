mov r0, #8 ;Numbers to be found
mov r1, #0 ;Numbers found so far
mov r2, #1;Current candidate
ldr r11, =4
increment_candidate: add r2, r2, #1
  mov r4, #1 ;First cube index
  mov r3, #0 ;Number of ways found
  increment_first_cube_index: mov r6, r2 
    mul r5, r4, r4
    mov r9, r5
    mul r5, r9, r4 ;obtain first cube from index  
    cmp r5, r2
    bgt increment_candidate
    sub r6, r2, r5 ;subtract first cube from temp
    add r4, r4, #1 ;increment first cube index
    mov r7, r4 ;initialize second cube index
    increment_second_cube_index: mul r8, r7, r7
      mov r10,r8
      mul r8, r10, r7 ;obtain second cube from index
      cmp r8, r6 ;compare second cube with changed temp
      bgt increment_first_cube_index
      add r7, r7, #1 ;increment second cube index
      cmp r8, r6
      bne increment_second_cube_index
      add r3, r3, #1
      cmp r3, #2 ;check if number of ways found is two
      bne increment_first_cube_index
      add r1, r1, #1 ;increment found numbers
      mul r12, r1, r11
      ldr r8, =0x1000
      str r2, [r12,r8] ;store the found number
  cmp r1, r0 ;check if program is complete
  bne increment_candidate