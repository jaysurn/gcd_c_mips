# A demonstration of some simple MIPS instructions
# used to test QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
				# Initializes variables for functions to use
	lw $s0, m_z		# To be used in the random number generation m_z
	lw $s1, m_w		# To be used in the random number generation m_w
	lw $s2, Result		# GCD's result
	lw $s5, A		# a
	lw $s6, B		# b
	li $t9, 0		# i=0 iterator for loop
	li $s6, 100000		# To pass 100000 in for later
	li $s7, 1		# To pass 1 in for later
				
				# Main for loop to run the function
				# It creates random values and computes the GCD of them
				# Then it prints the values of them to the console
Loop:	move $a0, $s7		# Passes 1 into low for Rrange
	move $a1, $s6		# Passes 100000 into high for Rrange
	jal Rrange		# Calls Rrange
	move $s5, $v0		# Moves Rrange's value to a
	sw $s5, A		# Saves value to A
	
	jal Rrange		# Calls Rrange
	move $s6, $v0		# Moves Rrange's value to b
	sw $s6, B		# Saves value to B
	
	move $a0, $s5		# Moves a in arg0 for GCD
	move $a1, $s6		# Moves b in arg1 for GCD
	jal GCD			# Calls GCD with a,b as inputs
	move $s2, $v0		# Move GCD's value to Result
	sw $s2, Result		# Saves value to Result
	
	li $v0, 4		# Loads integer for syscall, print strings
	la $a0, msg1		# Loads msg1 for printing
	syscall			# Sends loads to the console GCD(
	
	li $v0, 1		# Loads integer for syscall, print strings
	lw $a0, A		# Loads a for printing
	syscall			# Sends loads to the console GCD(a
	
	li $v0, 4		# Loads integer for syscall, print strings
	la $a0, msg2		# Loads msg2 for printing
	syscall			# Sends loads to the console GCD(a,
	
	li $v0, 1		# Loads integer for syscall, print strings
	lw $a0, B		# Loads b for printing
	syscall			# Sends loads to the console GCD(a,b
	
	li $v0, 4		# Loads integer for syscall, print strings
	la $a0, msg3		# Loads msg3 for printing
	syscall			# Sends loads to the console GCD(a,b) = 
	
	li $v0, 1		# Loads integer for syscall, print strings
	lw $a0, Result		# Loads Result for printing
	syscall			# Sends loads to the console GCD(a,b) = Result
	
	li $v0, 4		# Loads integer for syscall, print strings
	la $a0, newln		# Loads Newline for printing
	syscall			# Sends loads to the console GCD(a,b) = Result \n
	
	add $t9, $t9,1		# i++;
	beq $t9, 10, exit	# If i<10 
	j Loop			# Jumps to exit
	

	
exit:	sw $s0, m_z		# Saves final m_z value
	sw $s1, m_w		# Saves final m_w value
	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
			
				# Creates a random value and turns it into a 32 bit result
				# For Rrange to use to to the random value in a range
				# Puts m_z,m_w and ra into Stacks use for later
random: add $sp, $sp, -4	# Makes Stack and moves down in the Stack
	sw  $s0, 0($sp)		# Push m_z onto Stack
	add $sp, $sp, -4	# Makes Stack and moves down in the Stack
	sw  $s1, 0($sp)		# Push m_w onto Stack
	add $sp, $sp, -4	# Make Stack
	sw  $ra, 0($sp)		# Push return address onto Stack
	lw  $s0, m_z		# Load Current m_z
	lw  $s1, m_w		# Load Current m_w
	srl $t0, $s0, 16 	# m_z>>16
	and $t1, $s0, 65535	# m_z & 65535
	mul $t2, $t1, 36969     # 36969* (m_z & 65535)
	add $s0, $t2, $t0	# m_z= 36969* (m_z & 65535)+ m_z>>16 
	sw  $s0, m_z		# saves value of m_z
	srl $t3, $s1, 16	# m_w>>16
	and $t4, $s1, 65535	# m_w & 65535
	mul $t5, $t4, 18000	# 18000* (m_w & 65535)
	add $s1, $t5, $t3	# m_w= 36969* (m_w & 65535)+ m_w>>16 
	sw  $s1, m_w		# saves value of m_w
	sll $t6, $s0, 16	# m_z<<16 (temp)
	addu $t6, $t6, $s1	# write as 32 bit result
	move $v0, $t6		# Moves result to v0 to be used
				# Popping Stack
	lw  $ra, 0($sp)		# Load return address with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	lw  $s1, 0($sp)		# Load m_w with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	lw  $s0, 0($sp)		# Load m_z with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	jr $ra			# Returns to Rrange and moves to the next line
	
				# Creates a random value within a certain range to be set
				# To A and B that'll be used for a GCD comparison
Rrange:	add $sp, $sp, -4	# Makes Stack and moves down in the Stack
	sw  $s0, 0($sp)		# Push High onto Stack
	add $sp, $sp, -4	# Makes Stack and moves down in the Stack
	sw  $s1, 0($sp)		# Push Low onto Stack
	add $sp, $sp, -4	# Make Stack
	sw  $ra, 0($sp)		# Push return address onto Stack
	move $s0, $a0		# Inputs high
	move $s1, $a1		# Inputs low
	sub $s1, $s0, $s1	# range= high-low
	add $s1, $s1, 1		# range =high-low +1
	jal random		# Calls random
	move $t2, $v0		# Inputs Random
	div $s1, $t2		# random/range
	mfhi $t1		# random % range
	add $a3, $t1,$s0	# (random % range) +low
	move $v0, $a3		# Moves random in range to v0 to be used
	
	lw  $ra, 0($sp)		# Load return address with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	lw  $s1, 0($sp)		# Load High with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	lw  $s0, 0($sp)		# Load Low with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	jr $ra			# Returns to main and moves to the next line
				
				# Calculates the GCD between A and B and then returns the value
GCD:	add $sp, $sp, -4	# Makes Stack and moves down in the Stack
	sw  $s0, 0($sp)		# Push A onto Stack
	add $sp, $sp, -4	# Makes Stack and moves down in the Stack
	sw  $s1, 0($sp)		# Push B onto Stack
	add $sp, $sp, -4	# Make Stack
	sw  $ra, 0($sp)		# Push return address onto Stack
	move $s0, $a0		# Input a
	move $s1, $a1		# Input b
	div $s0, $s1		# a/b
	mfhi $t0		# a%b
	beq $t0, 0, GCDone	# If a%b==0 goto GCDone
	move $a0, $s1		# Load arg0 with b
	move $a1, $t0		# Load arg1 with a%b
	j GCD			# Go back to top of GCD and do again till a%b==0
	
GCDone: lw  $ra, 0($sp)		# Load return address with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	lw  $s1, 0($sp)		# Load A with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	lw  $s0, 0($sp)		# Load B with Stack pointer value
	add $sp, $sp, 4		# Moves to next place in Stack
	move $v0, $s1		# Prepare answer to retun
	jr $ra  		# Return to last place in code +1 line
	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)
m_z:	.word 60000		# Memory reserved for int 'm_z's memory address
m_w:	.word 50000		# Memory reserved for int 'm_w's memory address
Result:	.word 0			# Memory reserved for int 'Result's memory address
A:	.word 0			# Memory reserved for int 'A's memory address
B:	.word 0			# Memory reserved for int 'B's memory address
msg0:	.asciiz "00000"		# To prevent memory leaking
msg1:	.asciiz "GCD("		# Print Statement 1
msg2:	.asciiz ","		# Print Statement 2
msg3:	.asciiz ") = "		# Print Statement 3
newln:	.asciiz "\n"		# New Line statement