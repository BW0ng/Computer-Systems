	# All program code is placed after the 
	# .text assembler directive
	.text 
	
# The label main represents the starting point 

# Macro making it easier to print new line
.macro printNewLine()
	li	$a0, 10
	li	$v0, 11
	syscall
.end_macro 

.macro printRegister(%register)
	add	$a0, %register, $zero
	li	$v0, 1
	syscall
	li	$a0, 44
	li	$v0, 11
	syscall 
	li	$a0, 20
	syscall 
	
.end_macro 

.macro printChar(%c)
	li	$a0, %c
	li	$v0, 11
	syscall 
.end_macro 

.macro printString()
	la 	$a0, string 
	li 	$v0, 4
	syscall
.end_macro 

main:
	# Print out MIPS Program By:
	la 	$a0, greeting 
	li 	$v0, 4
	syscall
	
	# Printing out Brandon Wong
	la 	$a0, name 
	li 	$v0, 4
	syscall  
	
	# Ask the user to input a number
	la	$a0, promptText
	li	$v0, 4
	syscall 
	
	# Syscall to enter a number
	jal	promptInt
	add	$s0, $v0, $zero		# inputtedValue
	
	addi	$s6, $zero, 1		# Setting a constant for 1
	
	jal initializeStack
	nop
	
	jal	initializeIJ
	nop
	
	# Store the $ra
	jal push
	nop
	
	jal	allocateArray
	nop
	
	jal initializeIJ
	nop
	
	# Store the $ra
	jal	push
	nop
	
	jal solveNQ
	nop
	
	printChar(123)
	printNewLine
	jal printArray
	nop
	
promptInt:
	li 	$v0, 5
	syscall
	add	$s0, $v0, $zero
	jr	$ra
	nop
	
allocateArray:
	
	add $a0, $s3, $zero
	li	$v0, 9
	syscall
	
	sb	$v0, array
	
	jal	initializeArray
	nop
	
initializeArray:
	beq $s1, $s0, pop
	
	mult $s1, $s0
	mflo $t0
	la  	$t1, array
	add	$t1, $t1, $s2
	add	$t1, $t1, $t0

	sb  $zero, 0($t1)
	
	addi	$s2, $s2, 1
	beq	$s2, $s0, increment
	
	j	initializeArray
	nop

	# Increment I in the for loop initialize array
increment:
	add $s2, $zero, $zero
	addi	$s1, $s1, 1
	j	initializeArray
	nop
	
	# increment I in the for loop for print array
incrementAndNewLine:
	add $s2, $zero, $zero
	addi	$s1, $s1, 1
	printNewLine
	j	printArray
	nop
	
initializeIJ:
	add $s1, $zero, $zero		# int i
	add	$s2, $zero, $zero		#int j
	jr $ra
	nop
	
saveVariableInArray:
	mult $a1, $s0
	mflo $t0
	la  	$t1, array
	add	$t1, $t1, $a0
	add	$t1, $t1, $t0

	sb  $a3, 0($t1)

	jr	$ra
	nop
	
printArray:
	beq $s1, $s0, end
	
	mult $s1, $s0
	mflo $t0
	la  	$t1, array
	add	$t1, $t1, $s2
	add	$t1, $t1, $t0
	
	lb $t0, 0($t1)
	
	printRegister($t0)
	addi	$s2, $s2, 1
	beq	$s2, $s0, incrementAndNewLine
	
	j	printArray
	nop
	
initializeStack:
	addi	$t0, $zero, 4
	mult	$t0, $s0
	mflo	$s3
	
	mult	$s3, $s0
	mflo	$s3
	
	addi	$t0, $zero, -1
	mult	$t0, $s3
	mflo	$t0
	
	add	$sp, $sp, $t0
	
	jr	$ra
	nop

# Creating a push method for the stack
push:
	add	$t0, $sp, $s3
	addi	$t1, $ra, 8
	sw	$t1, 0($t0)		
	addi	$s3, $s3, -4
	jr	$ra
	nop
pushr:
	add	$t0, $sp, $s3
	addi	$t1, $ra, 4
	sw	$t1, 0($t0)		
	addi	$s3, $s3, -4
	jr	$s7
	nop
# Creating a pop method and storing it in $s4
pop:
	add	$t0, $sp, $s3
	addi	$t0, $t0, 4
	lw	$t1, 0($t0)
	addi	$s3, $s3, 4
	jr	$t1
	nop
	
noSolution:
	la 	$a0, noSolutionText 
	li 	$v0, 4
	syscall
	
solveNQ:
	add	$a0, $zero, $zero
	add	$s5, $zero, $zero
	jal	push
	nop
	jal	solveNQUtil
	nop
	beq	$v0, $zero, noSolution
	jal	pop

solveNQUtil:
	addi	$a0, $a0, -1	# Subtracts 1 so col >= inputtedValue rather than col < inputtedValue
	beq	$a0, $s0, return1		# if (col >= inputtedValue) return
	nop
	addi	$a0, $a0, 1
	beq	$s5, $s0, return0
	nop
	jal	push
	nop
	add	$a1, $s5, $zero		# Setting $a1 = i, because a0 = col
	jal	isSafe
	nop
	beq	$v0,	$s0, return1
	jal	isSafe
	nop
	beq	$v0, $s6, set1
	nop
	jal	push
	nop
	addi	$a0, $a0, 1
	jal	solveNQUtil
	nop
	beq	$v0, $zero, return1
	nop
	jal	set0
	nop
	j	return0
	nop
isSafe:
	printString()
	add	$s7, $zero, $zero 		#Initializing $s7 = i = 0
	jal	pop
	nop
	jal	firstForLoop
	nop
	add	$s7, $zero, $a0			# Setting $s7 = col
	add	$s4, $zero, $a1			# Setting $s4 = row
	jal	secondForLoop
	nop 
	add	$s7, $zero, $a0			# Setting $s7 = col
	add	$s4, $zero, $a1			# Setting $s4 = row
	jal	thirdForLoop
	nop
	j	return1
	nop

firstForLoop:
	beq	$s7, $a0, pop
	add $a3, $zero, $s7
	jal	check
	nop
	addi	$s7, $s7, 1
	jal	firstForLoop
	nop	

secondForLoop:
	addi	$t0, $zero, -1
	beq	$s7, $t0, pop
	beq	$s4, $t0, pop
	jal	check
	addi	$s7, $s7, -1
	addi	$s4, $s4, -1
	jal	secondForLoop
	nop

thirdForLoop:				# Setting $s7 = col = j  Setting $s4 = row = i
	addi	$t0, $zero, -1
	add	$t1, $s0, 1
	beq	$s7, $t0, pop
	beq	$s4, $t1, pop
	jal	check
	addi	$s7, $s7, -1
	addi	$s4, $s4, 1
	jal	thirdForLoop
	nop
	
check:
	mult $a1, $s0
	mflo $t0
	la  	$t1, array
	add	$t1, $t1, $a3
	add	$t1, $t1, $t0

	lb  $t2, 0($t1)

	beq	$t2, $s6, return0
	nop

set1:
	la	$t0, pushr
	jalr	$s7, $t0		# Jalr Saves $ra in $s7 and return address in $t0
	addi	$a3, $zero, 1
	jal	saveVariableInArray
	nop
	jr	$ra
	
set0:
	la	$t0, pushr
	jalr	$s7, $t0
	add	$a3, $zero, $zero
	jal	saveVariableInArray
	nop
	jr	$ra
	
return1:
	addi $v0, $zero, 1
	j	pop
	nop

return0:
	add	$v0, $zero, $zero
	j	pop
	nop
end:
	printChar(125)
	printNewLine()
	li 	$v0, 10
	syscall 
	
	.data 
greeting: 			.asciiz "\nMIPS Program By: "
name:	  		.asciiz  "Brandon Wong\n"
promptText:	 	.asciiz "Enter a number: "
noSolutionText:	.asciiz "Solution does not exist\n"
string:			.asciiz 	"isSafe\n"
array:			.space 	4
