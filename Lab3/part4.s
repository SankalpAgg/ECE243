/*The code will run slower on CPUlator than DE1-Soc board as CPULator*/
/*is just a simulation and not actual hardware*/
/*To achieve a delay of 0.25 seconds on the board we can use 1000000*/
/*loop iterations but for a much smaller delay we can use 500000 loop iterations*/

/* Program to Count the number of 1’s and Zeroes in a sequence of 32-bit words,
and determines the largest of each */
.global _start
_start: movia r4,TEST_NUM/*r4 has address of TEST_NUM in memory*/
movia r6, TEST_NUM/*r6 has address of TEST_NUM in memory*/
movia r16,LargestOnes/*r16 has address of LargestOnes in memory*/
movia r17,LargestZeroes/*r17 has address of LargestZeroes in memory*/
ldw r18,(r4)/*r18 has the value at address of r14 in memory*/
movi r3,0/*r3<- 0*/
movi r8,0/*r8<- 0*/
movi r23, 0xFFFFFFFF/*r23 <- -1*/
movia r25, LEDS/*r25 has address of LEDS*/

forloop: 
beq r18,r0,stop1/*if r18 = 0 go to stop1*/
movi r2,0/*r2 <- 0*/
call ONES /*subroutine is called*/
addi r4,r4,4/* r4 <- r4 + 1*/
ldw r18,(r4)/*value at address of r4 is loaded into r18*/
bgt r3,r2,forloop/*if r3 > r2, go to forloop*/
mov r3,r2/*r3 <- r2*/
beq r3,r2,forloop/*if r3 = r2, go to forloop*/

forzero:movi r2,0/*r2 <- 0*/
ldw r7,(r6)/* r7 has value from memory at address of r6*/
beq r7,r0,stop1/*if r7 = 0 go to stop1*/
xor r7,r7,r23/* r7 < r7 ^ r23*/
call ONES/* subroutine is called*/
addi r6,r6,4/*r6 < r6 + 4*/
ldw r7,(r6)/* r7 has value from memory at address of r6*/
bgt r8,r2,forzero/*if r8 > r2, go to forzero*/
mov r8,r2/*r8 <- r2*/
beq r8,r2,forzero/*if r8 = r2, go to forzero*/

stop1: stw r3,(r16)/*store into memory value in r3 at r16*/
stw r12,(r17)/*store into memory value in r12 at r17*/

endiloop: 
stwio r3, (r25)
call timedelay/*subroutine called*/
stwio r12, (r25)
call timedelay/*subroutine called*/
br endiloop/*branch to endiloop*/

ONES: ldw r9,(r4) /* r9 has the value in memory present at InputWord's address */
movi r11,1 /* r11 <- 1 */
movi r14,1 /* r14 <- 1 */
movi r15,32 /* r15 <- 32 */
mov r12,r0 /* counter */

loop: and r10,r9,r11 /* r10 <- r9 && r11 */
if: beq r10,r11,inc /* if r10 = r11 go to inc */
else: beq r10,r0,same /* if r10 = 0 go to same */
inc: addi r12,r12,1 /* r12 <- r12 + 1 */


mov r13,r9 /*r13 <- r9*/
srli r13,r13,31 /*checking fot the signed bit*/
beq r13,r0,stop /*r13 = 0 go to stop*/
br check /*go to check*/

check: add r12,r12,r11 /*r12 <- r12 + r11 */
stop:
same: srli r9,r9,1 /*r9>>1 */
add r14,r14,r11 /* r14 <- r14 + 1 */
blt r14,r15,loop /* if r14 < r15 go to loop */
mov r2,r12/*r2 <- r12*/
ret

timedelay:
mov r5,r0/*r5 <- 0*/
movia r1, 3500000/*r1 <- 3500000*/
go:add r5, r5, r11/*r5 <- r5 + r11*/
bne r5, r1, go/*if r5 != 1 go to go*/
ret/*return */

.data

.equ LEDS, 0xff200000
TEST_NUM:  .word 0x4a01fead, 0xF677D671,0xDC9758D5,0xEBBD45D2,0x8059519D
            .word 0x76D8F0D2, 0xB98C9BB5, 0xD7EC3A9E, 0xD9BADC01, 0x89B377CD
            .word 0  # end of list
LargestOnes: .word 0
LargestZeroes: .word 0
	
	
	
	

	
	
	
	
	
	
	
	
	
	
