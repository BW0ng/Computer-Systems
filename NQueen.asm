## Need to write pop and push methods for stack
	
		
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
	
	jal allocateArray
	nop
	
	j	printArray
	nop
	
	#jal	solveNQ
	#nop
	
	
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
	
	#addi	$t2, $zero, 4		# saving 4 to multiple input in
	#mult	$s0, $t2			# Multiplying to figure out how many bytes to save
	#mflo		$t2		# Saving byte amount
	# addi		$sp, $sp, 5  #FIXME
	
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
	beq $s1, $s0, printBrackets
	
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
	
	
return:
	jr	$s7
	nop
	
solveNQ:
	# Allocate and initialize array
	jal	allocateArray
	nop
	
	add	$a0, $zero, $zero		# Setting 0 in the parameters
	jal	solveNQUtil			# calling solveNQUtil(0)
	nop
	
	beqz $v0, noSolution
	
	# Initialize variables for use in print Array
	add $s1, $zero, $zero		# int i
	add	$s2, $zero, $zero		#int j
	
	printChar(123)
	printNewLine
	jal printArray
	nop
	
solveNQUtil:
	#sb	$ra, 0($sp)
	jal return1
	nop
	jal solveNQUtil
	nop
	
return1:
	add	$v0, $zero, 1
	#lb	$ra, 0($sp)
	#printRegister($ra)
	jr $ra
	nop
	
noSolution:
	la	$a0, noSolutionText
	li	$v0, 4
	syscall 
	j	end
	nop
	
printBrackets:
	printChar(125)
	printNewLine()
	j	end
	nop

end:
	li 	$v0, 10
	syscall 
	
	.data 
greeting: .asciiz "\nMIPS Program By: "
name:	  .asciiz  "Brandon Wong\n"
promptText:	  .asciiz "Enter a number: "
noSolutionText:	.asciiz	"Solution does not exist\n"
array:		.space 	4
