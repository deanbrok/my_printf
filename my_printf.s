hello:
	.asciz "Hel%%lo De%%an!\n"

helloend: 
  .equ length, helloend - hello			#find length of the String


gotit:
	.asciz "\nYou have a % sign!\n"

gotitend:
	.equ length1, gotitend - gotit	
	

.global main

main:

  movq $hello, %rbx 								#move the string to register %rbx
  call recognize                    #call subroutine

	movq $60 , %rax 
	movq $0 , %rdx 
	syscall

	
got_print:
	movq $1, %rax
	movq $1, %rdi
	movq $gotit, %rsi
	movq $length1, %rdx
	syscall
	jmp endreg
	

recognize: 


	movq $length, %r9                 #store length in register %r9 
  movq $0, %r8     								  #initialize %rdx as the loop counter	

  loop:
  	
  	cmpq %r8, %r9										#compare the pointer to the length of the string
  	je endreg												#jump to end if they are equal
		incq %r8
  	cmpb $'%', 0(%rbx)			#move the character at position %r8 to %cl 				
  	jne print
  	je case
		#je got_print									#go to formatstring to deal with different cases  
	
		

  endreg:
  	ret
	
	print:
		movq $1, %rax
		movq $1, %rdi
		movq %rbx, %rsi
		movq $1, %rdx
		syscall

		incq %rbx
		jmp loop
	
	case:
		incq %rbx
		cmpb $'%', 0(%rbx)
		je print
		jmp loop
	
	percentsign:
		

 
  

  
	
