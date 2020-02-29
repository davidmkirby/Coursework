/********************************************************************************/
/*																				*/
/*			ECE 344L		-	Microprocessors	-		Spring 2020				*/
/*																				*/
/*			lab2.S			MIPS Assembly Nested Routines						*/
/*																				*/
/********************************************************************************/
/*																				*/
/*			Author:		David Kirby												*/
/*																				*/
/********************************************************************************/
/*																				*/
/*			Detailed File Description:											*/
/*				Implements stack operations to perform dot products on			*/
/*				vectors.														*/
/*																				*/
/********************************************************************************/
/*																				*/
/*			Revision History:													*/
/*				First Revision													*/
/*																				*/
/********************************************************************************/

/*#include <p32xxxx.h>*/	# only include this C header if NOT using $ notation
.globl main

# Part 1:
#	Write a main routine in which two n x 1 vectors are defined in a similar
#	manner to how numbers_to_use: is implemented in lab 0. (n must be equal to
#	6 and some of the values must be negative numbers – no values should be 0).

.data               
vector1: .word 1,1,-3,4,-5,6	# defining our 1st set of 6x1 vectors
vector2: .word 1,-2,3,4,5,-6	# defining our 2nd set of 6x1 vectors

.text

.set noreorder				# keeps the order

.ent main					# the assembler enters here

# Part 2:
#	Your main program will configure the stack pointer appropriately and pass
#	the parameters to a function called dot_product. Do NOT use registers to
#	pass the parameters to the dot product function and do NOT pass pointers to
#	the arrays. References to the input arguments and output values will all be
#	relative to the stack pointer. You will use the stack to return the dot
#	product result to main, as well as the two vector average values.

main:
# vector1:
	lw $s0, vector1+0x00	# load our vectors from memory
	lw $s1, vector1+0x04
	lw $s2, vector1+0x08
	lw $s3, vector1+0x0C
	lw $s4, vector1+0x10
	lw $s5, vector1+0x14
# vector2:
	lw $t0, vector2+0x00
	lw $t1, vector2+0x04
	lw $t2, vector2+0x08
	lw $t3, vector2+0x0C
	lw $t4, vector2+0x10
	lw $t5, vector2+0x14

# stack pointer configuration:
	addi $sp, $sp, -64		# allocate room on the stack (12 digits + 4 temp)
	# vector1:
		sw $s0,  4($sp)		# push our vectors to the stack
		sw $s1, 12($sp)
		sw $s2, 20($sp)
		sw $s3, 28($sp)
		sw $s4, 36($sp)
		sw $s5, 44($sp)
	# vector2:
		sw $t0,  8($sp)
		sw $t1, 16($sp)
		sw $t2, 24($sp)
		sw $t3, 32($sp)
		sw $t4, 40($sp)
		sw $t5, 48($sp)

	addi $t7, $sp, 0		# record our current stack position
	jal dot_product			# jump and link our return address
	nop
	addi $sp, $sp, 64		# after the jump, push result to stack, & end
	b end_m
	nop

dot_product:
	add $s0, $zero, $0
	add $s1, $zero, $0
	b average
	nop

average:
	lw $t0, 4($t7)			# pops vector1 from stack
	lw $t1, 8($t7)			# pops vector2 from stack
	
	beq $s0, 6, end_math	# end if we've reached our 6th value
	nop
	sw $ra, 52($sp)			# else store return address

	jal multiply			# then jump to the multiplication part
	nop
	lw $v0, 60($sp)			# after jump, pops return value from stack
	bltz $v1, end_m
	nop

	addi $a0, $s1, 0
	addu $s1, $v0, $s1		# accumulate multiplications into $s1

	jal overflow
	nop

	lw $ra, 52($sp)
	addi $s0, $s0, 1
	addi $t7, $t7, 8		# check the average status
	b average
	nop

multiply:
	mult $t0, $t1			# LO = (($t0 * $t1)<<32) >> 32;HI = ($t0 * $t1)>>32;
	mflo $t0				# $t0 = LO
	mfhi $t1				# $t1 = HI (store HI into a register to be checked)
	sra $t2, $t0, 31		# shift right arithmetic by 31

	bne $t2, $t1, of_else	# checks HI = 0, branch to overflow else
	nop

	sw $t0, 60($sp)			# if no overflow, push to stack

	li $v1, 0

	jr $ra
	nop

of_else:
	li $v1, -1				# if overflow, set $v1 to -1
	li $v0 , 0				# if overflow, set $v0 to 0
	b end_m
	nop

end_math:
	jr $ra					# after multiplication, return address
	nop

overflow:
	bgtz $v0, positive
	nop
	b negative
	nop

positive:
	bltz $a0, of_good		# overflow good
	nop
	bltz $s1, of_else		# overflow else
	nop

	jr $ra
	nop

negative:
	bgtz $a0, of_good		# overflow good
	nop
	bgtz $s1, of_else		# overflow else
	nop

	jr $ra
	nop

of_good:					# if overflow good, jump back to $ra
	jr $ra
	nop

end_m:
	nop						# creates an infinite loop
	b end_m
	nop

.end main