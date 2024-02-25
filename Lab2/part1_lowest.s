.global _start
_start:

movia r8,result# the address of the result
ldw r9,4(r8)# the number of numbers is in r9
movia r10,array# the address of the array is in r10
ldw r11,(r10)/* keep smallest number so far in r11 */

loop: subi r9,r9,1/* loop to search for smallest number */
ble r9,r0,fin
addi r10,r10,4# add 4 to pointer to the numbers to point to next one
ldw r12,(r10)# load the next number into r12
blt r11,r12,loop # if the current smallest is still smallest, go to loop
mov r11,r12  # otherwise new number is smallest, put it into r11
br loop
fin: stw r11,(r8) # store the answer into result
.equ    LEDs, 0xFF200000
    movia r23, LEDs
    stwio r11, (r23)
infloop: br infloop

result: .word 0
n: .word 15
array: .word 4,5,3,6,1, 2, 2, 10, 9, 12, -1, 13, 15, 9, 18
	
	
