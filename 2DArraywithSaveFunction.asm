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
	
	add $s1, $zero, $zero		# int i
	add	$s2, $zero, $zero		#int j
	
	jal	allocateArray
	nop
	
	add $s1, $zero, $zero		# int i
	add	$s2, $zero, $zero		#int j
	
	add	$a0,	$s2, $zero
	add	$a1, $s1, $zero
	addi	$a3, $zero, 1
	jal	saveVariableInArray
	nop
	addi	$a0, $a0, 1
	addi	$a3, $zero, 5
	jal	saveVariableInArray
	nop
	addi	$a0, $a0, 1
	addi	$a3, $zero, 3
	jal	saveVariableInArray
	nop
	
	
	add $s1, $zero, $zero		# int i
	add	$s2, $zero, $zero		#int j
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
	add	$s7, $ra, $zero
	mult $s0, $s0
	mflo $s3
	
	add $a0, $s3, $zero
	li	$v0, 9
	syscall
	
	sb	$v0, array
	
	jal	initializeArray
	nop
	
initializeArray:
	beq $s1, $s0, return
	
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
	add $s2, $zero, $zero
	addi	$s1, $s1, 1
	j	initializeArray
	nop
	
incrementAndNewLine:
	add $s2, $zero, $zero
	addi	$s1, $s1, 1
	printNewLine
	j	printArray
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
saveVariableInArray:
	mult $a1, $s0		#save variables(i, j)			a1 = i = row		a0 = j = col
	mflo $t0
	la  	$t1, array
	add	$t1, $t1, $a0
	add	$t1, $t1, $t0

	sb  $a3, 0($t1)

	jr	$ra
	nop
return:
	jr	$s7
	nop
	
end:
	printChar(125)
	printNewLine()
	li 	$v0, 10
	syscall 
	
	.data 
greeting: .asciiz "\nMIPS Program By: "
name:	  .asciiz  "Brandon Wong\n"
promptText:	  .asciiz "Enter a number: "
array:		.space 	4
