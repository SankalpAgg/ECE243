/*    Subroutine to display a four-bit quantity as a hex digits (from 0 to F) 
      on one of the six HEX 7-segment displays on the DE1_SoC.
*
 *    Parameters: the low-order 4 bits of register r4 contain the digit to be displayed
		  if bit 4 of r4 is a one, then the display should be blanked
 *    		  the low order 3 bits of r5 say which HEX display number 0-5 to put the digit on
 *    Returns: r2 = bit patterm that is written to HEX display
 */

.equ HEX_BASE1, 0xff200020#moving address of HEX0-3 
.equ HEX_BASE2, 0xff200030#moving address of HEX4-5


.global _start 

_start: mov r11,r0#r11 <- 0

hexloop: mov r4,r11#r4 <- r11
movi r5,0#r5 <- 0
call HEX_DISP#calling subroutine
call timedelay#calling subroutine
mov r4,r11#r4 <- r11
movi r5,1#r5 <- 1
call HEX_DISP#calling subroutine
call timedelay#calling subroutine
mov r4,r11#r4 <- r11
movi r5,2#r5 <- 2
call HEX_DISP#calling subroutine
call timedelay#calling subroutine
mov r4,r11#r4 <- r11
movi r5,3#r5 <- 2
call HEX_DISP#calling subroutine
call timedelay#calling subroutine
mov r4,r11#r4 <- r11
movi r5,4#r5 <- 4
call HEX_DISP#calling subroutine
call timedelay#calling subroutine
mov r4,r11#r4 <- r11
movi r5,5#r5 <- 5
call HEX_DISP#calling subroutine

change:
movi r14,0x10#moving 10000 to r14
beq r11,r14,reset#if r11 = r14, go to reset
addi r11,r11,1#r11 <- r11 + 1
br hexloop#branch to hex loop

reset:
mov r11, r0#r11 <- 0
br hexloop#branch to hexloop
	
timedelay:
mov r12,r0#r12 <- 0
movia r13, 10000000#moving a large value into r13
go:addi r12, r12, 1#r12 <- r12 + 1
bne r12, r13, go#if r12 != r13, go to go
ret#return

HEX_DISP:   movia    r8, BIT_CODES         # starting address of the bit codes
	    andi     r6, r4, 0x10	   # get bit 4 of the input into r6
	    beq      r6, r0, not_blank 
	    mov      r2, r0
	    br       DO_DISP
not_blank:  andi     r4, r4, 0x0f	   # r4 is only 4-bit
            add      r4, r4, r8            # add the offset to the bit codes
            ldb      r2, 0(r4)             # index into the bit codes

#Display it on the target HEX display
DO_DISP:    
			movia    r8, HEX_BASE1         # load address
			movi     r6,  4
			blt      r5,r6, FIRST_SET      # hex4 and hex 5 are on 0xff200030
			sub      r5, r5, r6            # if hex4 or hex5, we need to adjust the shift
			addi     r8, r8, 0x0010        # we also need to adjust the address
FIRST_SET:
			slli     r5, r5, 3             # hex*8 shift is needed
			addi     r7, r0, 0xff          # create bit mask so other values are not corrupted
			sll      r7, r7, r5 
			addi     r4, r0, -1
			xor      r7, r7, r4  
    			sll      r4, r2, r5            # shift the hex code we want to write
			ldwio    r5, 0(r8)             # read current value       
			and      r5, r5, r7            # and it with the mask to clear the target hex
			or       r5, r5, r4	           # or with the hex code
			stwio    r5, 0(r8)		       # store back
END:			
			ret
			
BIT_CODES:  .byte     0b00111111, 0b00000110, 0b01011011, 0b01001111
			.byte     0b01100110, 0b01101101, 0b01111101, 0b00000111
			.byte     0b01111111, 0b01100111, 0b01110111, 0b01111100
			.byte     0b00111001, 0b01011110, 0b01111001, 0b01110001

            .end
			

	
