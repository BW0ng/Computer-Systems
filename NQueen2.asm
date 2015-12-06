	# All program code is placed after the 
	# .text assembler directive
	.text 
	
# The label main represents the starting point 

# Macro making it easier to print new line
.macro printNewLine()
	add	$t7, $a0, $zero
	li	$a0, 10
	li	$v0, 11
	syscall
	add	$a0, $t7, $zero
.end_macro 

.macro printRegister(%register)
	add	$t7, $a0, $zero
	add	$a0, %register, $zero
	li	$v0, 1
	syscall
	li	$a0, 44
	li	$v0, 11
	syscall 
	li	$a0, 20
	syscall 
	add	$a0, $t7, $zero
.end_macro 

.macro printChar(%c)
	add	$t7, $a0, $zero
	li	$a0, %c
	li	$v0, 11
	syscall 
	add	$a0, $t7, $zero
.end_macro 

.macro printString()
	la	$t0, counter
	lb	$t1, 0($t0)
	addi	$t2, $t1, 1
	sb	$t2, 0($t0)

	printRegister($t1)
	printChar(41)
	printChar(32) 
	
	add	$t0, $a0, $zero
	la 	$a0, string 
	li 	$v0, 4
	syscall
	add	$a0, $t0, $zero
.end_macro 

.macro print()
	jal	initializeIJ
	nop
	printChar(123)
	printNewLine
	jal	printArray
	nop
	printChar(125)		# end method
	printNewLine()
.end_macro 

main:
	addi	$t0, $zero, 1
	la	$t1, counter
	sb	$t0, 0($t1)
	
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
	nop
	add	$s0, $v0, $zero		# inputtedValue
	
	addi	$s6, $zero, 1		# Setting a constant for 1
	
	jal initializeStack
	nop
	
	jal	initializeIJ
	nop
	
	jal	allocateArray
	nop
	
	jal initializeIJ
	nop
	
	jal solveNQ
	nop
	
	print()
	j end
	nop
	
promptInt:
	li 	$v0, 5	#prompting integer
	syscall
	add	$s0, $v0, $zero
	jr	$ra
	nop
	
allocateArray:
	la	$t0, pushr		# Set 1 in the array
	jalr	$s7, $t0		# Jalr Saves $pc in $s7 and jumps to $t0
	nop
	add $a0, $s3, $zero		# allocating the space for the array
	li	$v0, 9
	syscall
	
	sb	$v0, array
	
	
	jal	initializeArray
	nop
	
initializeArray:
	beq $s1, $s0, pop		# Saving zeros in the array
	
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

increment:
	add $s2, $zero, $zero		# Increment I in the for loop initialize array
	addi	$s1, $s1, 1
	j	initializeArray
	nop
	
	
incrementAndNewLine:
	add $s2, $zero, $zero		# increment I in the for loop for print array
	addi	$s1, $s1, 1
	printNewLine()
	j	printArray
	nop
	
initializeIJ:
	add $s1, $zero, $zero		# int i
	add	$s2, $zero, $zero		#int j
	jr $ra
	nop
	
saveVariableInArray:
	mult $a1, $s0		#save variables(i, j)			a1 = i = row		a0 = j = col
	mflo $t0
	la  	$t1, array
	add	$t1, $t1, $a0
	add	$t1, $t1, $t0

	sb  $a3, 0($t1)

	jr	$ra
	nop
	
printArray:
	beq $s1, $s0, return		# printArray
	
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
	add	$s3, $zero, $zero
	addi	$t0, $zero, 4		# initialize the stack
	mult	$t0, $s0
	mflo	$t1
	
	mult	$t1, $s0
	mflo	$t1
	
	addi	$t0, $zero, -1
	mult	$t0, $t1
	mflo	$t0
	
	add	$sp, $sp, $t0
	
	jr	$ra
	nop

push:
	add	$t0, $sp, $s3		# Creating a push method for the stack
	addi	$t1, $ra, 8
	sw	$t1, 0($t0)		
	addi	$s3, $s3, 4
	jr	$ra
	nop
	
pushr:
	add	$t0, $sp, $s3		# Creating a push method for the stack for set0 and set1
	addi	$t1, $ra, 4
	sw	$t1, 0($t0)		
	addi	$s3, $s3, 4
	jr	$s7
	nop

pop:
	addi	$s3, $s3, -4		# Subtracting it so it gets the value before
	add	$t0, $sp, $s3		# Creating a pop method and storing it in $s4
	lw	$t1, 0($t0)
	jr	$t1
	nop
	
popLoop:
	addi	$s3, $s3, -8		# Subtracting it so it gets the value before
	add	$t0, $sp, $s3		# Creating a pop method and storing it in $s4
	lw	$t1, 0($t0)
	jr	$t1
	nop
	
noSolution:
	la 	$a0, noSolutionText 	# print no solutions text
	li 	$v0, 4
	syscall
	
solveNQ:
	la	$t0, pushr		# Set 1 in the array
	jalr	$s7, $t0		# Jalr Saves $pc in $s7 and jumps to $t0
	nop
	add	$a0, $zero, $zero		# solve NQ method - main method to start NQ
	add	$s5, $zero, $zero
	jal	push
	nop
	jal	solveNQUtil
	nop
	beq	$v0, $zero, noSolution
	j	pop
	nop
solveNQUtil:
	la	$t0, pushr		# Set 1 in the array
	jalr	$s7, $t0		# Jalr Saves $pc in $s7 and jumps to $t0
	nop
	printString()
	addi	$a0, $a0, -1	# Subtracts 1 so col >= inputtedValue rather than col < inputtedValue
	beq	$a0, $s0, return1		# if (col >= inputtedValue) return
	nop
	addi	$a0, $a0, 1
	jal	push
	nop
	jal	NQUtilForLoop
	nop
	j	return0
	nop
NQUtilForLoop:
	beq	$s5, $s0, return0
	nop
	add	$a1, $s5, $zero		# Setting $a1 = i, because a0 = col
	jal	push
	nop
	jal	isSafe
	nop
	jal	push
	nop
	beq	$v0, $s6, set1
	nop
	addi	$a0, $a0, 1
	jal	push
	nop
	jal	solveNQUtil
	nop
	beq	$v0, $s6, return1
	jal	set0
	nop
	addi	$s5, $s5, 1
	j NQUtilForLoop
	nop
	
isSafe:
	add	$s7, $zero, $zero 		#Initializing $s7 = i = 0
	jal	push
	nop
	jal	firstForLoop
	nop
	add	$s7, $zero, $a0			# Setting $s7 = col
	add	$s4, $zero, $a1			# Setting $s4 = row
	jal	push
	nop
	jal	secondForLoop
	nop 
	add	$s7, $zero, $a0			# Setting $s7 = col
	add	$s4, $zero, $a1			# Setting $s4 = row
	jal	push
	nop
	jal	thirdForLoop
	nop
	j	return1
	nop

firstForLoop:
	beq	$s7, $a0, pop		# first for loop
	add $a3, $zero, $s7
	jal	check
	nop
	addi	$s7, $s7, 1
	j	firstForLoop
	nop	

secondForLoop:
	addi	$t0, $zero, -1		# second for loop
	beq	$s7, $t0, pop
	beq	$s4, $t0, pop
	jal	check
	nop
	addi	$s7, $s7, -1
	addi	$s4, $s4, -1
	j	secondForLoop
	nop

thirdForLoop:				# Setting $s7 = col = j  Setting $s4 = row = i
	addi	$t0, $zero, -1		# third foor loop
	add	$t1, $s0, 1
	beq	$s7, $t0, pop
	beq	$s4, $t1, pop
	jal	check
	nop
	addi	$s7, $s7, -1
	addi	$s4, $s4, 1
	j	thirdForLoop
	nop
	
check:
	mult $a1, $s0			# check and see if array($a1, $a3) = 1
	mflo $t0
	la  	$t1, array
	add	$t1, $t1, $a3
	add	$t1, $t1, $t0

	lb  $t2, 0($t1)

	beq	$t2, $s6, return0
	nop
	jr	$ra
set1:
	la	$t0, pushr		# Set 1 in the array
	jalr	$s7, $t0		# Jalr Saves $pc in $s7 and jumps to $t0
	nop
	addi	$a3, $zero, 1
	jal	saveVariableInArray
	nop
	print()
	j	pop
	nop
set0:
	la	$t0, pushr		# Set 0 in the array
	jalr	$s7, $t0
	nop
	add	$a3, $zero, $zero
	jal	saveVariableInArray
	nop
	print()
	j pop
	nop
	
return1:
	addi $v0, $zero, 1		# return 1
	j	popLoop
	nop

return0:
	add	$v0, $zero, $zero		# return 0
	j	popLoop
	nop
return:
	jr	$ra
	nop
end:	
	li 	$v0, 10
	syscall 
	
	.data 
greeting: 			.asciiz "\nMIPS Program By: "
name:	  		.asciiz  "Brandon Wong\n"
promptText:	 	.asciiz "Enter a number: "
noSolutionText:	.asciiz "Solution does not exist\n"
string:			.asciiz 	"NQUtil\n"
counter:			.space	4
array:			.space 	4
