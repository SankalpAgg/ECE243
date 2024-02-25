.section .exceptions, "ax"
IRQ_HANDLER:
        # save registers on the stack (et, ra, ea, others as needed)
        subi    sp, sp, 20          # make room on the stack
        stw     et, 0(sp)#storing et(exception type) on stack
        stw     ra, 4(sp)#storing ra(return address) on stack   
        stw     r20, 8(sp)#storing r20 on stack
		stw r22, 16(sp)#storing r22 on stack
		
        rdctl   et, ctl4            # read exception type
        beq     et, r0, SKIP_EA_DEC # not external?
        subi    ea, ea, 4           # decrement ea by 4 for external interrupts

SKIP_EA_DEC:
        stw     ea, 12(sp)
        andi    r20, et, 0x2        # check if interrupt is from pushbuttons
        bne     r20, et, calltimer    # if not, ignore this interrupt
		beq et, r22, calltimer#if et = r22, go to calltimer
		call KEY_ISR#call subroutine
		movia r20, RUN#move memory mapped value into r20
		ldw r20, (r20)#load it into r20
		beq r20, r0, END_ISR#if r20 = 0, go to END_ISR
		
		
calltimer:
		call TIMER_ISR#call subroutine
		br END_ISR#branch back to END_ISR

END_ISR:
        ldw     et, 0(sp)           # restore registers
        ldw     ra, 4(sp)
        ldw     r20, 8(sp)
        ldw     ea, 12(sp)
		ldw r22, 16(sp)
        addi    sp, sp, 20          # restore stack pointer
        eret                        # return from exception

		




.section .exceptions, "ax"
KEY_ISR: #subroutine ---> KEY Interrupt Service Routine
	stack:
		subi sp, sp, 60#storing registers on the stack
		stw r2, 16(sp)
		stw r4, 20(sp)
		stw r5, 24(sp)
		stw r6, 28(sp)
		stb r7, 32(sp)
		stw r16, 36(sp)
		stw r17, 40(sp)
		stw r18, 44(sp)
		stw r19, 48(sp)
		stw r21, 52(sp)
		stw ra, 56(sp)
		
	checkPress:
		movia r4, RUN#move memory mapped value from RUN into r4
		movia r5, KEY_BASE#move memory mapped value from KEY_BASE into r5
		movi r16, 0x1#r16 <- 1
		movi r17, 0x2#r17 <- 2
		movi r18, 0x4#18 <- 4
		ldwio r19, 0xC(r5)#load value from edge capture r5 into r19
		movi r21, 15#r21 <- 15
		stwio r21, 0xC(r5)#storing value in r21 into edge capture r5
		
		beq r19, r16, KEY0#if r19 = r16, KEY0 is pressed
		beq r19, r17, KEY1#if r19 = r17, KEY1 is pressed
		beq r19, r18, KEY2#if r19 = r18, KEY2 is pressed
		

	KEY0:
		ldwio r6, 0xC(r5)
		movi r16, 1
		ldw r7, (r4)
		beq r7, r16, stopTimer
		bne r7, r16, startTimer
	
	KEY1:
		movia r16, TIMER_BASE
		movia r17, COUNTER_DELAY
		ldw r18, (r17)
		srli r18, r18, 1
		stw r18, (r17)
		
		
		stwio      r0, 0(r16)         # clear TO bit
        srli       r19, r18, 16           # Split 32 bit number into 16+16
        andi       r18, r18, 0xFFFF       # keep the lower 16 bits
        stwio      r18, 0x8(r16)         # write lower 16 bits to the timer
        stwio      r19, 0xc(r16)         # write lower 16 bits to the timer
		movi r19, 8
		stwio r19, 0x4(r16)
        movi       r18, 7           # Enable CONT and Start
        stwio      r18, 0x4(r16)
		br END_KEY_ISR

		
		
	KEY2:
		movia r16, TIMER_BASE
		movia r17, COUNTER_DELAY
		ldw r18, (r17)
		slli r18, r18, 1
		stw r18, (r17)
		
		
		stwio      r0, 0(r16)         # clear TO bit
        srli       r19, r18, 16           # Split 32 bit number into 16+16
        andi       r18, r18, 0xFFFF       # keep the lower 16 bits
        stwio      r18, 0x8(r16)         # write lower 16 bits to the timer
        stwio      r19, 0xc(r16)         # write lower 16 bits to the timer
		movi r19, 8
		stwio r19, 0x4(r16)
        movi       r18, 7           # Enable CONT and Start
        stwio      r18, 0x4(r16)
		br END_KEY_ISR

		
		
	stopTimer:
		movi r16, 0
		stw r0, (r4)
		br END_KEY_ISR
		
	startTimer:
		movi r16, 1
		stw r16, (r4)
		br END_KEY_ISR

	END_KEY_ISR:
		ldw r2, 16(sp)
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
		
		
		
		


.section .exceptions, "ax"

TIMER_ISR:
	
	stacktimer:
		subi sp, sp, 20
		stw r16, 0(sp)
		stw r17, 4(sp)
		stw r18, 8(sp)
		stw r19, 12(sp)
		stw r4, 16(sp)
	
		movia r16, TIMER_BASE
		movia r4, RUN
		
		stwio r0, (r16)
		ldw r17, (r4)
		beq r17, r0, donotincrement
		beq r17, r16, increment
	
	increment:
		movia r18, COUNT
		ldw r19, (r18)
		addi r19, r19, 1
		stw r19, (r18)

	donotincrement:
		br END_TIMER_ISR
	
	END_TIMER_ISR:
		ldw r16, 0(sp)
		ldw r17, 4(sp)
		ldw r18, 8(sp)
		ldw r19, 12(sp)
		ldw r4, 16(sp)
		addi sp, sp, 20
		ret
	

.text
.global  _start

	.equ      TIMER_BASE, 0xFF202000
	.equ      COUNTER_DELAY, 500000
	.equ	  LED_BASE, 0xff200000
	.equ      KEY_BASE, 0xff200050

_start:
    /* Set up stack pointer */
	movia sp, 0x20000
	movia r4, TIMER_BASE
	movia r5, KEY_BASE
	movi r11, 0
	movi r16, 1
	movi r17, 3
	movi r18, 0
	movi r19, 0
	
	
	
    call    CONFIG_TIMER        # configure the Timer
    call    CONFIG_KEYS         # configure the KEYs port
    /* Enable interrupts in the NIOS-II processor */
	
	wrctl ctl3, r17
	wrctl ctl0, r16

    movia   r8, LED_BASE        # LEDR base address (0xFF200000)
    movia   r9, COUNT           # global variable
	
	

	
LOOP:
		#stwio      r0, 0(r4)         # clear TO bit

    ldw     r10, 0(r9)          # global variable
    stwio   r10, 0(r8)          # write to the LEDR lights
    br      LOOP
	

CONFIG_TIMER:             # code not shown
		subi sp, sp, 12
		stw r4, 0(sp)
		stw r8, 4(sp)
		stw r9, 8(sp)
		
	setuptimer:
		movia r4, TIMER_BASE
		movia r8, COUNTER_DELAY
		
		
		stwio      r0, 0(r4)         # clear TO bit
        srli       r9, r8, 16           # Split 32 bit number into 16+16
        andi       r8, r8, 0xFFFF       # keep the lower 16 bits
        stwio      r8, 0x8(r4)         # write lower 16 bits to the timer
        stwio      r9, 0xc(r4)         # write lower 16 bits to the timer
		movi r9, 8
		stwio r9, 0x4(r4)
        movi       r8, 7           # Enable CONT and Start
        stwio      r8, 0x4(r4)


	endtimersetup:
		ldw r4, 0(sp)
		ldw r8, 4(sp)
		ldw r9, 8(sp)
		addi sp, sp, 12
		ret




CONFIG_KEYS:         # code not shown
		subi sp, sp, 4
		stw r11, 0(sp)
		
	enableINTMASK:
		movi r11, 15
		stwio r11, 8(r5)
		stwio r11, 0xC(r5)
		
	endkey:
		ldw r11, 0(sp)
		addi sp, sp, 4
		ret


.data
/* Global variables */
.global  COUNT
COUNT:  .word    0x0            # used by timer

.global  RUN                    # used by pushbutton KEYs
RUN:    .word    0x1            # initial value to increment COUNT

.end
	
	
	
	
	
