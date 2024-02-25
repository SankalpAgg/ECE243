.global _start
_start:
.text
/* Program to Count the number of 1’s in a 32-bit word,
located at InputWord */

movia r8,InputWord/*r8 has the address of InputWord*/
movia r16,Answer/*r16 has the address of Answer*/
ldw r9,(r8)/*r9 has the value in memory present at InputWord's address*/ 
movi r11,1/*r11 <- 1*/
movi r14,1/*r14 <- 1*/
movi r15,32/*r15 <- 32 */
mov r12,r0/*counter*/
loop: and r10,r9,r11 /* r10 <- r9 && r11*/
if: beq r10,r11,inc /* if r10 = r11 go to inc*/
else: beq r10,r0,same/*if r10 = 0 go to same*/
inc: addi r12,r12,1/*r12 <- r12 + 1*/
same: add r12,r12,r0/*r12 <- r12 + 0*/
srli r9,r9,1/*shift r9 rightwards by 1 bit*/
addi r14,r14,1/* r14 <- r14 + 1*/
blt r14,r15,loop/*if r14 < r15 go to loop*/
stw r12,(r16)/* store value of r12 in memory at r16's address*/
endiloop: br endiloop/*infinite loop*/
.data
InputWord: .word 0x4a01fead
Answer: .word 0
