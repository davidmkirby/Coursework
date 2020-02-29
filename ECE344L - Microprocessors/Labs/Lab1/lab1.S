/********************************************************************************/
/*																*/
/*		ECE 344L		-	Microprocessors	–		Spring 2020		*/
/*																*/
/*		lab1.S		MIPS Assembly Addition & Multiplication				*/
/*																*/
/********************************************************************************/
/*																*/
/*		Author:		David Kirby									*/
/*																*/
/********************************************************************************/
/*																*/
/*		Detailed File Description:									*/
/*			Implements a loop of arithmetic operations and tests for		*/
/*			overflow control.										*/
/*																*/
/********************************************************************************/
/*																*/
/*		Revision History:											*/
/*			Changed bgez to bgtz to correct for over-instantiation			*/
/*																*/
/********************************************************************************/

#include <p32xxxx.h>

.globl main
	
.text			# tells the assembler that we are in the text section

.set noreorder		# tells the assembler to keep the order in which we have put it

.ent main			# tells the assembler where to enter the routine called main

main:
	li t0, 0
	li v0, 0		#  starting register
	li v1, 0		# overflow signalling register
	li s1, 0		# incremented register
	li s2, 600	# limit register
	li s3, 0		# overflow storing register
	li s4, 0

main_loop:		# destination,source,transform
	add v0,v0,s1	# v0 = v0 + s1
	addi s1,s1,2	# s1 = s1 + 2
	sub s4,s1,s2	# s4 = s1 - s2 (are we below our limit register)
	bgtz s4,next	# s4 > 0 (keep counting till difference between our limit
				# and incremented values are zero)
	nop			# if greater than/equal to limit, goto next
	b main_loop	# else continue loop
	nop

next:
	addi s1,s1,-2		# decrement our incremented register back to our limit
	mult v0,v0		# LO = ((v0 * v0)<<32) >> 32;HI = (v0 * v0)>>32;
	mflo t0			# t0 = LO
	mfhi s3			# s3 = HI (store HI into a register to be checked)
	bgtz s3,overflow	# s3 > 0 (if there's a value, we have overflow, decrement)
	nop
	move v1,t0		# v1 = t0 (if no overflow, store our result to v1)
	b end_m
	nop

overflow:
	li v1,-1		# if there's an overflow, decrement
	b end_m
	nop

end_m:
	nop			# creates an infinite loop
	b end_m
	nop

.end main
