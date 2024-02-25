.global _start
.equ KEY_BASE, 0xFF200050
.equ LEDs, 0xFF200000

_start:
    movia r8, KEY_BASE
    movia r9, LEDs

    movi r17, 0      /* Initialize counter status to stopped */
   

main_loop:
    ldwio r14, 0xC(r8)   /* Read Edge Capture register */

    /* Check if any button is pressed */
    bne r14, r0, handle_button

    /* If no button is pressed, check the counter status */
    beq r17, r0, increment_counter

    br main_loop

handle_button:
    /* Button pressed, reset Edge Capture register to acknowledge */
    movi r15, 0xFFFFFFFF
    stwio r15, 0xC(r8)

    /* Toggle counter status on button press */
    xori r17, r17, 1

    br main_loop

increment_counter:
    /* Increment binary counter */
    addi r10, r10, 1
    movi r11, 256
    beq r10, r11, reset_counter

    /* Display counter on LEDs */
    stwio r10, 0(r9)

    /* Delay for approximately 0.25 seconds */
    call timedelay

    br main_loop

reset_counter:
    movi r10, 0
    br main_loop

timedelay:
    mov r12, r0 /* r5 <- 0 */
    movia r13, 2500000 /* r13 <- 2500000 */
go:
    addi r12, r12, 1 /* r12 <- r12 + 1 */
    bne r12, r13, go /* if r12 != r13 go to go */
    ret /* return */

	
	
	
	
	
