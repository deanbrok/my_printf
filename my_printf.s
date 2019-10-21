.text
hello:
	.asciz "Hello%s%s%s%s%s%s%s\n"

helloend: 
  .equ length, helloend - hello			#find length of the String

yes:
 .asciz "\nYes?\n"
 
dean:
 .asciz "I am Dean\n"

nice:
 .asciz "Nice to meet you Dean\n"

same:
 .asciz "Same here!\n"

janice:
 .asciz "I am Janice\n"   
 
date:
 .asciz "Wanna go on a date?\n"  
 

got:
	.asciz "You got it!"



.global main

main:

	pushq %rbp                  #pushes the base pointer
  movq %rsp, %rbp             #moves the base pointer to the stack pointer
	
	pushq $got
	pushq $date
	movq $janice, %r9
	movq $same, %r8
	movq $nice, %rcx
	movq $dean, %rdx
	movq $yes , %rsi
	movq $hello, %rdi
	
  
  call recognize                    #call subroutine
   
                   
  movq  %rbp, %rsp            # clears local variables
  popq  %rbp                  # restores base pointermulq %rdi     
                
	
	movq $60 , %rax 
	movq $0 , %rdx 
	syscall
	
recognize: 
	pushq %rbp                  #pushes the base pointer
  movq %rsp, %rbp             #moves the base pointer to the stack pointer
  
  movq $0, %r12											#set argument counter to 0
  
  pushq %r9
  pushq %r8
  pushq %rcx
  pushq %rdx
  
  pushq %rsi
	movq %rdi, %rbx 
									
	movq $16, %r15
	
	movq $length, %r9                 #store length in register %r9 
  movq $0, %r8     								  #initialize %rdx as the loop counter	
	
  loop:
  	
  	cmpq %r8, %r9										#compare the pointer to the length of the string
  	je endreg												#jump to end if they are equal
		incq %r8
  	cmpb $'%', 0(%rbx)			#move the character at position %r8 to %cl 				
  	jne print
  	je case
	
	

  endreg:
  	movq  %rbp, %rsp            # clears local variables
  	popq  %rbp                  # restores base pointer
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
		incq %r8
		cmpb $'%', 0(%rbx)
		je print
		cmpb $'s', 0(%rbx)
		je print_string
		cmpb $'u', 0(%rbx)
		je print_unsigned
		cmpb $'d', 0(%rbx)
		jmp loop
	
print_string:
	#check the value of the counter and branch to the argument	
	cmpq $5, %r12	
	jge stack		
	movq (%rsp), %r11
		
	#print out the string and increment the parameter counter by 1
	output:
	movq $0,%r10  		
	incq %r12
		
		output_loop:
		incq %r10
		incq %r11
		cmpb $0, 0(%r11)
		jne output_loop
			
	movq $1, %rax
	movq $1, %rdi
	popq %rsi
	movq %r10, %rdx
	syscall

	incq %rbx
	jmp loop
		
		
	stack:	
		movq (%r15, %rbp), %r11 
		addq $8, %r15
		pushq %r11
		jmp output

  
	
