.global _start
_start:
	
movi r8,0
movi r9,30
movi r12,0

forloop: 
addi r8,r8,1
add r12,r12,r8
blt r8,r9,forloop
         
  fin: br fin

	
	
	
