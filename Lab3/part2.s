.global _start
_start: movia r4,InputWord
movia r16,Answer
call ONES
stw r2,(r16)
endiloop: br endiloop /* infinite loop */

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

.data
InputWord: .word 0x4a01fead
Answer: .word 0

	
	
