
.text


percentsign:
	.asciz "%"

negativesign:
	.asciz "-"

hello:
	.asciz "I am Dean Nguyen %u %s%d %d %r %d %u %d %d\n"

helloend: 
  .equ length, helloend - hello			#find length of the String

yes:
 .asciz "Yes?"
 
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
	
	/*
	pushq $got
	pushq $date
	movq $janice, %r9
	movq $same, %r8
	movq $nice, %rcx
	movq $dean, %rdx
	
	movq $yes, %rsi
  */
	
	pushq $0
	pushq $-55
	pushq $4
	movq $-6, %r9
	movq $-7, %r8
	movq $-8, %rcx
	movq $yes, %rdx
	movq $9223372036854775809, %rsi
	movq $hello, %rdi
	
  
  call recognize                    #call subroutine
   
                   
  movq  %rbp, %rsp            # clears local variables
  popq  %rbp                  # restores base pointermulq %rdi     
                
	
	movq $60 , %rax 
	movq $0 , %rdx 
	syscall

print_percent:
		movq $1, %rax
		movq $1, %rdi
		movq $percentsign, %rsi
		movq $1, %rdx
		syscall
		ret

	
	
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
		je print_signed

		call print_percent
		jmp loop
	
print_string:
	#check the value of the counter and branch to the argument	
	
		
	cmpq $5, %r12	
	jge stack		
	
	#the case when fewer than 6 arguments were used
	movq (%rsp), %r11
		
	#print out the string and increment the parameter counter by 1
	output:
	movq $0,%r10  		#initialize the length of the string
	incq %r12
		
		#find the length of the string
		output_loop:
		incq %r10
		incq %r11
		cmpb $0, 0(%r11)
		jne output_loop
			
	#print out the string with the length found
	movq $1, %rax
	movq $1, %rdi
	popq %rsi
	movq %r10, %rdx
	syscall

	incq %rbx
	jmp loop
		
	#get values from the stack 
	stack:	
		movq (%r15, %rbp), %r11 
		addq $8, %r15
		pushq %r11
		jmp output	 
			
					
print_unsigned:
		
		#check the number of arguments and jump to the stack if needed
		cmpq $5, %r12	
		jge stack1		
		

		start:
			incq %r12
			movq $-1, %r13   
			popq %rax
			
		
		#divide the value by 10 until it reaches 0, push the remainder on the stack and increment the loop counter by 1 each time		
		count:
			movq $10, %r14
			xor %rdx, %rdx
			divq %r14
			addq $48, %rdx
			pushq %rdx
			incq %r13
			cmpq $0, %rax
			jne count
		
		#starts printing when the previous loop is over, prints out each value on the stack 
		print_u:
			
			movq $1, %rax
			movq $1, %rdi
			movq %rsp, %rsi
			movq $1, %rdx
			syscall
			addq $8, %rsp
			cmpq $0, %r13
			jne decrement
			
			incq %rbx
			jmp loop
			
  		decrement:
				decq %r13	
				jmp print_u

		#get values from the stack if the number of arguments used is 6 or more
		stack1:
			movq (%r15, %rbp), %rax 
			addq $8, %r15
			pushq %rax
			jmp start	 
			

print_signed:
		

		cmpq $5, %r12	
		jge stack2		
		
		#check whether the value is negative and jump to the negative case else continue to print as usual
		start1:
			incq %r12
			movq $-1, %r13   
			popq %rax
			cmpq $0, %rax
			jl print_negative
			back:
			movq $10, %r14
		
		#similar to count
		count1:
			
			xor %rdx, %rdx
			idivq %r14
			addq $48, %rdx
			pushq %rdx
			incq %r13
			cmpq $0, %rax
			jne count1
		
		#similar to print_u
		print_d:
			
			movq $1, %rax
			movq $1, %rdi
			movq %rsp, %rsi
			movq $1, %rdx
			syscall
			addq $8, %rsp
			cmpq $0, %r13
			jne decrement1
			
			incq %rbx
			jmp loop
			
  		decrement1:
				decq %r13	
				jmp print_d
		
		#use the stack if needed
		stack2:
			movq (%r15, %rbp), %rax 
			addq $8, %r15
			pushq %rax
			jmp start1	 
			
		#print out a negative sign and negate the value 
		print_negative:
			pushq %rax
			movq $1, %rax
			movq $1, %rdi
			movq $negativesign, %rsi
			movq $1, %rdx
			syscall
			popq %rax
			neg %rax
			jmp back
