/******************************************************************************
 * Write an interrupt service routine
 *****************************************************************************/
.section .exceptions, "ax"
IRQ_HANDLER:
        # save registers on the stack (et, ra, ea, others as needed)
        subi    sp, sp, 16          # make room on the stack
        stw     et, 0(sp)
        stw     ra, 4(sp)
        stw     r20, 8(sp)

        rdctl   et, ctl4            # read exception type
        beq     et, r0, SKIP_EA_DEC # not external?
        subi    ea, ea, 4           # decrement ea by 4 for external interrupts

SKIP_EA_DEC:
        stw     ea, 12(sp)
        andi    r20, et, 0x2        # check if interrupt is from pushbuttons
        beq     r20, r0, END_ISR    # if not, ignore this interrupt
        call    KEY_ISR             # if yes, call the pushbutton ISR

END_ISR:
        ldw     et, 0(sp)           # restore registers
        ldw     ra, 4(sp)
        ldw     r20, 8(sp)
        ldw     ea, 12(sp)
        addi    sp, sp, 16          # restore stack pointer
        eret                        # return from exception
		
		
		
		
.section .exceptions, "ax"
KEY_ISR: #subroutine ---> KEY Interrupt Service Routine
	stack:
		subi sp, sp, 60#storing registers on the stack
		stw r2, 16(sp)#storing r2 on the stack
		stw r4, 20(sp)#storing r4 on the stack
		stw r5, 24(sp)#storing r5 on the stack
		stw r6, 28(sp)#storing r6 on the stack
		stb r7, 32(sp)#storing r7 on the stack
		stw r16, 36(sp)#storing r16 on the stack
		stw r17, 40(sp)#storing r17 on the stack
		stw r18, 44(sp)#storing r18 on the stack
		stw r19, 48(sp)#storing r19 on the stack
		stw r21, 52(sp)#storing r21 on the stack
		stw ra, 56(sp)#storing ra on the stack
		
	checkwhichkey:
		movia r2, KEYS#moving memory mapped address value into r2
		movia r21, HEX_BASE1#moving HEX_BASE1 memory mapped value into r21
		movi r16, 1#r16 <- 1
		movi r17, 2#r17 <- 2
		movi r18, 4#r18 <- 4
		movi r19, 8#r19 <- 8
		ldwio r5, 0xC(r2)#loading value from edge capture
		andi r6, r5, 15#r6 <- r5 & 1111
		beq r6, r16, KEY0#if r6 = r16, go to KEY0
		beq r6, r17, KEY1#if r6 = r17, go to KEY1
		beq r6, r18, KEY2#if r6 = r18, go to KEY2
		beq r6, r19, KEY3#if r6 = r19, go to KEY3
		
		
	KEY0:
		movi r4, 0#r4 <- 0
		movi r5, 0#r5 <- 0
		movi r6, 1#r6 <- 1
		ldbio r7, 0(r21)#load byte from r21 into r7
		stwio r6, 0xC(r2)#store value into edge capture
		bne r7, r0, blank0#if r7 != 0, go to blank
		call HEX_DISP#call subroutine
		br END_KEY_ISR #branch to END_KEY_ISR
		
		
	KEY1:
		movi r4, 1#r4 <- 0
		movi r5, 1#r5 <- 0
		movi r6, 2#r6 <- 1
		ldbio r7, 1(r21)#load byte from r21 into r7
		stwio r6, 0xC(r2)#store value into edge capture
		bne r7, r0, blank1#if r7 != 0, go to blank
		call HEX_DISP#call subroutine
		br END_KEY_ISR#branch to END_KEY_ISR
		
		
	KEY2:
		movi r4, 2#r4 <- 2
		movi r5, 2#r5 <- 2
		movi r6, 4#r6 <- 4
		ldbio r7, 2(r21)#load byte from r21 into r7
		stwio r6, 0xC(r2)#store value into edge capture
		bne r7, r0, blank2#if r7 != 0, go to blank
		call HEX_DISP#call subroutine
		br END_KEY_ISR#branch to END_KEY_ISR
		
		
	KEY3:
		movi r4, 3#r4 <- 3
		movi r5, 3#r5 <- 3
		movi r6, 8#r6 <- 8
		ldbio r7, 3(r21)#load byte from r21 into r7
		stwio r6, 0xC(r2)#store value into edge capture
		bne r7, r0, blank3#if r7 != 0, go to blank
		call HEX_DISP#call subroutine
		br END_KEY_ISR#branch to END_KEY_ISR
		
	blank0:
		movi r4, 16#r4 <- 16
		movi r5,0 #r5 <- 0
		stwio r6, 0xC(r2)#store value into edge capture
		call HEX_DISP#call subroutine
		br END_KEY_ISR#branch to END_KEY_ISR
		
	blank1:
		movi r4, 17
		movi r5, 1
		stwio r6, 0xC(r2)
		call HEX_DISP
		br END_KEY_ISR
		
	blank2:
		movi r4, 18
		movi r5, 2
		stwio r6, 0xC(r2)
		call HEX_DISP
		br END_KEY_ISR
		
		
	blank3:
		movi r4, 19
		movi r5, 3
		stwio r6, 0xC(r2)
		call HEX_DISP
		br END_KEY_ISR
		
		
	END_KEY_ISR:
		ldw r2, 16(sp)#restoring registers from the stack
		ldw r4, 20(sp)
		ldw r5, 24(sp)
		ldw r6, 28(sp)
		ldb r7, 32(sp)
		ldw r16, 36(sp)
		ldw r17, 40(sp)
		ldw r18, 44(sp)
		ldw r19, 48(sp)
		ldw r21, 52(sp)
		ldw ra, 56(sp)
		addi sp, sp, 60
		ret
		
		
		
		
		
		
		
		
		
		
		
		







/*********************************************************************************
 * set where to go upon reset
 ********************************************************************************/
.section .reset, "ax"
        movia   r8, _start
        jmp    r8

/*********************************************************************************
 * Main program
 ********************************************************************************/
.text
.global  _start
_start:
        /*
        1. Initialize the stack pointer
        2. set up keys to generate interrupts
        3. enable interrupts in NIOS II
        */
		
		movia sp, 0x20000
		
		movia r8, KEYS
		
		movi r10, 2
		
		wrctl ctl3, r10
		
		movi r11, 15
		
		stwio r11, 8(r8)
		
		stwio r11, 0xC(r8)
		
		movi r9, 1
		
		wrctl ctl0, r9
		
		movi r16, 0
		movi r17, 0
		movi r18, 0
		movi r19, 0
		
loop:				# this is a do-nothing loop, except can keep an eye on r2 & r4
     		# to make sure they aren't over-written
      br loop
		
		
		
		
IDLE:   br  IDLE









/*    Subroutine to display a four-bit quantity as a hex digits (from 0 to F) 
      on one of the six HEX 7-segment displays on the DE1_SoC.
*
 *    Parameters: the low-order 4 bits of register r4 contain the digit to be displayed
		  if bit 4 of r4 is a one, then the display should be blanked
 *    		  the low order 3 bits of r5 say which HEX display number 0-5 to put the digit on
 *    Returns: r2 = bit patterm that is written to HEX display
 */

.equ HEX_BASE1, 0xff200020
.equ HEX_BASE2, 0xff200030

HEX_DISP:   
		subi sp, sp, 12
		stw r8, 4(sp)
		stw r7, 8(sp)
		
		movia    r8, BIT_CODES         # starting address of the bit codes
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
			ldw r8, 4(sp)
			ldw r7, 8(sp)
			addi sp, sp, 12
			ret
			
			
			
			
			
			
			
			
			
.data

.equ KEYS, 0xff200050
.equ HEX_BASE1, 0xff200020
.equ HEX_BASE2, 0xff200030
			
BIT_CODES:  .byte     0b00111111, 0b00000110, 0b01011011, 0b01001111
			.byte     0b01100110, 0b01101101, 0b01111101, 0b00000111
			.byte     0b01111111, 0b01100111, 0b01110111, 0b01111100
			.byte     0b00111001, 0b01011110, 0b01111001, 0b01110001

            
			.end















	
	
	
	
	
