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
	printChar(44)
	printChar(20)

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
	
	addi $s1, $zero, 4
	mult $s0, $s1
	mflo $s1
	mult $s0, $s1
	mflo $s1

	add $a0, $zero, $s1
	li $v0, 9
	syscall
	add $s1, $v0, $zero

	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	addi $a0, $s1, 0
	addi $a1, $zero, 0
	addi $a2, $s0, 0
	jal solve
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	nop
	bne $v0, $zero, if
		nop
		li $v0, 4
		la $a0, noSolution
		syscall
		j end
		nop
	# $s0 = size
	# $s1 = board
	# $s2 = 4
if:
	add $s2, $zero, $zero		# i
	add $s3, $zero, $zero		# j
	printChar(123)
	printNewLine()
printArray:
	beq $s2, $s0, return		# printArray
	
	mult $s2, $s0
	mflo $t0
	add  $t1, $s3, $t0
	addi	$t2, $zero, 4
	mult	$t1, $t2
	mflo	$t2
	add	$t1, $s1, $t2
	
	lb $t0, 0($t1)
	
	printRegister($t0)
	
	addi	$s3, $s3, 1
	beq	$s3, $s0, incrementAndNewLine
	
	j	printArray
	nop
incrementAndNewLine:
	add	$s3, $zero, $zero
	addi $s2, $s2, 1		# increment I in the for loop for print array
	printNewLine()
	j	printArray
	nop
solve:
	# $s0 = board
	# $s1 = column
	# $s2 = width or height
	# $s3 = i
	# $s4 = j
	# $s5 = k
	# $s6 = -1
	# $s7 = value inarray
	# $t0 = 4
	# $t1 = isSafe
	# $t2 = 1
	# $t3 = slt result
	# $t4 = array item

	# Parameters
	addi $s0, $a0, 0
	addi $s1, $a1, 0
	addi $s2, $a2, 0

	addi $s3, $zero, 0
	addi $s4, $zero, 0
	addi $s5, $s1, 0
	addi $s6, $zero, -1
	addi $s7, $zero, 0
	addi $t0, $zero, 4
	addi $t1, $zero, 1
	addi $t2, $zero, 1
	addi $t3, $zero, 0
	
	beq $s1, $s2, returnOne
	nop
for:
	slt $t3, $s3, $s2
	beq $t3, $zero, afterFor
	addi $t1, $zero, 1
	addi $s4, $zero, 0
	addi $s5, $s1, 0
forOne:
	slt $t3, $s4, $s1
	beq $t3, $zero, afterForOne
	nop
	mult $s2, $s3
	mflo $s7
	add $s7, $s7, $s4
	mult $s7, $t0
	mflo $s7
	add $s7, $s7, $s0
	lw $t4, 0($s7)
	bne $t4, $t2, afterIfOne
	nop
	addi $t1, $zero, 0
	j afterForThree
	nop
	afterIfOne:
	addi $s4, $s4, 1
	j forOne
	nop
afterForOne:
	addi $s4, $s3, 0
forTwo:
	slt $t3, $s6, $s4
	beq $t3, $zero, afterForTwo
	nop
	slt $t3, $s6, $s5
	beq $t3, $zero, afterForTwo
	nop
	mult $s4, $s2
	mflo $s7
	add $s7, $s7, $s5
	mult $s7, $t0
	mflo $s7
	add $s7, $s7, $s0
	lw $t4, 0($s7)
	bne $t4, $t2, afterIfTwo
	nop
	addi $t1, $zero, 0
	j afterForThree
afterIfTwo:
	addi $s4, $s4, -1
	addi $s5, $s5, -1
	j forTwo
	nop
afterForTwo:
	addi $s4, $s3, 0
	addi $s5, $s1, 0
forThree:
	slt $t3, $s6, $s5
	beq $t3, $zero, afterForThree
	nop
	slt $t3, $s4, $s2
	beq $t3, $zero, afterForThree
	nop
	mult $s4, $s2
	mflo $s7
	add $s7, $s7, $s5
	mult $s7, $t0
	mflo $s7
	add $s7, $s7, $s0
	lw $t4, 0($s7)
	bne $t4, $t2, afterIfThree
	nop
	addi $t1, $zero, 0
	j afterForThree
afterIfThree:
	addi $s4, $s4, 1
	addi $s5, $s5, -1
	j forThree
	nop
afterForThree:
	bne $t1, $t2, afterIfFour
	nop
	mult $s3, $s2
	mflo $s7
	add $s7, $s7, $s1
	mult $s7, $t0
	mflo $s7
	add $s7, $s7, $s0
	sw $t2, 0($s7)
	addi $sp, $sp, -56
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $t0, 32($sp)
	sw $t1, 36($sp)
	sw $t2, 40($sp)
	sw $t3, 44($sp)
	sw $t4, 48($sp)
	sw $ra, 52($sp)
	addi $a0, $s0, 0
	addi $a1, $s1, 1
	addi $a2, $s2, 0
	jal solve
	nop
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $t0, 32($sp)
	lw $t1, 36($sp)
	lw $t2, 40($sp)
	lw $t3, 44($sp)
	lw $t4, 48($sp)
	lw $ra, 52($sp)
	addi $sp, $sp, 56
	bne $v0, $t2, afterIfFive
	nop
	j returnOne
	nop
afterIfFive:
	mult $s3, $s2
	mflo $s7
	add $s7, $s7, $s1
	mult $s7, $t0
	mflo $s7
	add $s7, $s7, $s0
	sw $zero, 0($s7)
	j afterIfFour
	nop
afterIfFour:
	addi $s3, $s3, 1
	j for
	nop
afterFor:
	j returnZero
	nop
returnZero:
	addi $v0, $zero, 0
	jr $ra
	nop
returnOne:
	addi $v0, $zero, 1
	jr $ra
	nop
noSolution:
	la 	$a0, noSolutionText 	# print no solutions text
	li 	$v0, 4
	syscall
	j	end
	
promptInt:
	li 	$v0, 5
	syscall
	add	$s0, $v0, $zero
	jr	$ra
	nop
return:
	printChar(125)
	printNewLine()
end:
	li 	$v0, 10
	syscall 
	
	.data 
greeting: .asciiz "\nMIPS Program By: "
name:	  .asciiz  "Brandon Wong\n"
promptText:	  .asciiz "Enter a number: "
noSolutionText:	.asciiz "Solution does not exist\n"
one:		.asciiz		"1"
zero:		.asciiz		"0"
space:		.asciiz		" "
newLine:	.asciiz		"\n"
array:		.space 	4
