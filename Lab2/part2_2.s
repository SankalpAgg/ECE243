.text  # The numbers that turn into executable instructions
.global _start
_start:

/* r13 should contain the grade of the person with the student number, -1 if not found */
/* r10 has the student number being searched */


	movia r10, 887795# r10 is where you put the student number being searched for
	/* Your code goes here */
	add r6,r6,r0 #r6 <- r6 + r0(0)
	add r7,r7,r0 #r7 <- r7 + r0(0)
	movia r8, result#address of result in memory is stored in r8
	movia r9, Snumbers#address of Snumbers in memory is stored in r9
	movia r11, Grades#address of Grades in memory is stored in r11
	loop: ldw r12, (r9)#load word stored in r9 in memory and store in r12
	beq r12,r0,stop#branch equal , if r12 = r0 go to stop
	beq r12,r10,next#branch equal , if r12 = r10 go to next
	addi r9,r9,4#r9 <- r9 + 4
	addi r6,r6,1#r6 <- r6 + 1
	br loop#branch loop, infinite loop
	stop: movi r13,-1#r13 <- -1
	stb r13,(r8)#store into memory address of r8 the value in r13
	.equ    LEDs, 0xFF200000
    movia r23, LEDs
    stwio r13, (r23)
	br stop#branch stop, infinite loop
	next: beq r6,r7,fin#branch equal, if r6 = r7 go to fin
	addi r11,r11,1#r11 <- r11 + 1
	addi r7,r7,1#r7 <- r7 + 1
	br next#branch next, infinite loop
	fin: ldb r13, (r11)#load byte stored in r11 in memory and store in r13
	stb r13,(r8)#store into memory address of r8 the value in r13

.equ    LEDs, 0xFF200000
    movia r23, LEDs
    stwio r13, (r23)
iloop: br iloop


.data  	# the numbers that are the data 

/* result should hold the grade of the student number put into r10, or
-1 if the student number isn't found */ 

result: .byte 0
		.align 2
/* Snumbers is the "array," terminated by a zero of the student numbers  */
Snumbers: .word 10392584, 423195, 644370, 496059, 296800
        .word 265133, 68943, 718293, 315950, 785519
        .word 982966, 345018, 220809, 369328, 935042
        .word 467872, 887795, 681936, 0

/* Grades is the corresponding "array" with the grades, in the same order*/
Grades: .byte 99, 68, 90, 85, 91, 67, 80
        .byte 66, 95, 91, 91, 99, 76, 68  
        .byte 69, 93, 90, 72
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
