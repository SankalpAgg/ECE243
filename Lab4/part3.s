.global _start

.equ KEY_BASE, 0xFF200050
.equ LEDs, 0xFF200000
.equ COUNTER_DELAY, 25000000
.equ TIMER_BASE, 0xFF202000

_start:
    movia sp, 0x20000 #Load sp with the address 0x20000
    movia r8, KEY_BASE #Load r8 with KEY_BASE
    movia r9, LEDs #Load r9 with LEDs
    mov r10, r0/*moving 0 into r10*/
	movi r5, 256 /*r5 <- 256*/
    movi r11, 0  #r11 <- 0
    movia r13, COUNTER_DELAY #moving value from COUNTER_DELAY to r13


increase:
    addi r10, r10, 1 #r10 <- r10 + 1
    beq r10, r5, reset #If r10 == 256, reset
    stwio r10, 0(r9) #storing it in r9 to display on the LEDs
    call delay/*calling the subroutine*/
	br done
	
stop:
    ldwio r14, 0xc(r8)   # Reading edge capture neg edge
    bne r14, r0, check #checking if any key is pressed
    beq r11, r0, increase #if no key is pressed, going to increase
    br stop
	
check:
    movia r15, 0xffffffff #To reset the edge capture register
    stwio r15, 0xc(r8) #Storing the value to memory to reset
    br stop

reset: movi r10, 0
               br stop

delay:     #From prof's notes in lecture 10 
		   
           movia      r16, TIMER_BASE      # base address of timer
           stwio      r0, (r16)         # clear the TO bit in case it is on
           movia      r17, COUNTER_DELAY    # load the delay value
           srli       r18, r17, 16      # For the high 16 bits
           andi       r17, r17, 0xffff  # For the low 16 bits
           stwio      r17, 0x8(r16)     # write to the timer period register (low) for the lo bits
           stwio      r18, 0xc(r16)     # write to the timer period register (high) for the hi bits
           movi       r17, 0b0110       # To enable continuous mode so that the timer can start the timer for the delay to begin
           stwio      r17, 0x4(r16)     # write to the timer control register and go into continuous mode 
									    
	
		   poll:      ldwio      r17, 0x0(r16)     #timer status
           		   	  andi       r17, r17, 0b1     # Check the TO bit
           		      beq        r17, r0, poll     # if TO bit is 0, branch to poll
           		      stwio      r0, (r16)         # Reset
		  
		  ret
			

	
	
	
