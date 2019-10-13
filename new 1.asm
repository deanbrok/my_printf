hello:
	.asciz "Hello  Dean!\n"

helloend: 
  .equ length, helloend - hello			#find length of the String

char:
	.asciz "%"

gotit:
	.asciz "\nYou have a % sign!\n"

gotitend:
	.equ length1, gotitend - gotit	
	

.global main

main:

  movq $hello, %rbx 								#move the string to be compared to register %rbx
  call recognize

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
	
	
my_printf:
	movq $1, %rax
	movq $1, %rdi
	movq %rbx, %rsi
	movq $1, %rdx
	syscall
	incq %rbx
	jmp loop	
	

recognize: 
	movq $length, %r9                 #store length in register %r9 
	movq $0, %r8     								  #initialize %rdx as the loop counter
	movq $char, %rcx									#move the character % we want to compare to %rcx
	movq 0(%rcx), %r12									#move the character % to %ch to be compared
	
	
  loop:
  	
  	cmpq %r8, %r9										#compare the pointer to the length of the string
  	je endreg												#jump to end if they are equal
  	movq (%r8, %rbx), %r11						#move the character at position %r8 to %cl 
  	incq %r8												#increment the pointer				
  	cmpq %r11, %r12										#compare the character in %cl to %
  	jne my_printf
	je got_print									#go to formatstring to deal with different cases  	
  	
		
  endreg:
  	ret
	