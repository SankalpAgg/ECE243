.global _start
_start:
	
movi r8,0 /*r8 <- 0 , moving 0 to register 8*/
movi r9,30 /*r9 <- 30 , moving 30 to register 9*, 30 is the upper limit in the for loop*/
addi r12,r0,0 /*r12 <- r0(0) + 0 , storing 0 in register 12*/

forloop: /*label*/
addi r8,r8,1 /*incrementing the value help is register 8 by 1, r8 <- r8 + 1*/
add r12,r12,r8 /* r12 <- r12 + r8, storing the sum in register 12 */
blt r8,r9,forloop /* using the condition branch less than, if r8 < r9 return to the label forloop else move to the next instruction*/
                 /*for loop running until r8 reaches 30*/
.equ    LEDs, 0xFF200000
    movia r25, LEDs
    stwio r12, (r25)
fin: br fin /*infinite loop, branch to fin*/

	
	
	
