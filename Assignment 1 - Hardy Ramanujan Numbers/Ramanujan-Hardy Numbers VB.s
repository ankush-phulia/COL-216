.equ SWI_Exit, 0X11

_start:
ldr r0, =100 @no of HR nos
ldr r11, =4 @word size in bytes
ldr r2, =0x1000 @memory location
ldr r12, =0x2000 @memory location
ldr r3, =2000 @number of cubes to be computed
ldr r4, =1
b compute_cube

compute_cube:mul r5, r4, r4
mov r6, r5
mul r5, r6, r4
str r5, [r12, #0]
add r12, r12, #4
add r4, r4, #1
cmp r4, r3
bne compute_cube
b init
init:
ldr r12, =0x1FFC @memory location
mov r5, #1
mov r6, #1
mov r7, #1
mov r8, #1

loop_one: cmp r5, r3
beq end
loop_two: cmp r6, r5 @second less than first
bge reset_r6
mov r7, r6
add r7, r7, #1
loop_three: cmp r7, r5 @third less than first
bge reset_r7
mov r8, r7
add r8, r8, #1
loop_four: cmp r8, r5 @edit
bge reset_r8
mul r1, r5, r11 @calculate address
ldr r9, [r12, r1] @cube of no 1
mul r1, r6, r11 @calculate address
ldr r10, [r12, r1] @cube of no 2
add r9, r9, r10 @sum of cubes of no.s 1 and 2
str r9, [r12,#0] @store sum in memory
mul r1, r7, r11 @calculate address
ldr r10, [r12, r1] @cube of no 3
sub r9, r9, r10
mul r1, r8, r11	@calculate address
ldr r10, [r12, r1] @cube of number 4
sub r9, r9, r10
cmp r9, #0 @compare difference of both sums with 0
beq found_hn @execute when HR no. found
blt reset_r8
ldr r9, [r12,#0]
add r8, r8, #1
b loop_four

reset_r6: mov r6, #1 @reset no. 2
add r5, r5, #1
b loop_one

reset_r7: mov r7, #1 @reset no.3
add r6, r6, #1
b loop_two

reset_r8: mov r8, #1 @reset no. 1
add r7, r7, #1
ldr r9, [r12,#0]
b loop_three

found_hn:sub r0, r0, #1 @decrement counter of HR no
ldr r9, [r12,#0]
str r9, [r2,#0] @store the HR no found into memory
add r2, r2, #4
cmp r0, #0
beq end
b reset_r8

end:swi SWI_Exit