#include <p32xxxx.h>

#This is also a comment
# //This as well
#/* This is a 
#	Multiple line comment*/
		
.globl main 	#this tells the assembler that there is a global routine called main

.data	#this tells the assembler that we're in the data section
	# All numbers must be given a type, 32 bit numbers are .long or .word
	#	16 bit are .short or .halfword 
	numbers_to_use: .long 20, 20, 10, 10, 5, 5, 0, 0
	/*These numbers will be stored in memory and
	accessed using load word instructions.*/
	
.text  			#this tells the assembler that we're in the text section

.set noreorder	#this tells the assembler to keep everything in the order that we've put it in

.set mem_lock, 0xA0000250 
#	/* This is the memory location which we 
#	will use to store the final result in.
#	We've told the assembler to associate the phrase
#	"mem_lock" with the address value. Much like the #define 
#	directive in C*/

.ent main 	#this will tell the assembler where to enter the routine called main

main: 		#this is where main will begin

	/* The lw instructions is for load word
		it will take the values at the address of 
		"numbers to use" and add an offest, then store
		the new value into the designated register*/
	lw s0, numbers_to_use+0x00 	#20
	lw s1, numbers_to_use+0x04	#20
	lw s2, numbers_to_use+0x08	#10
	lw s3, numbers_to_use+0x0C	#10
	lw s4, numbers_to_use+0x10	#5
	lw s5, numbers_to_use+0x14	#5
	lw s6, numbers_to_use+0x18	#0
	lw s7, numbers_to_use+0x1C	#0
	
	/* the li instruction is for load immediate
		it is a combination of the load upper immediate
		(lui) and or immediate (ori) instructions.
		It loads the designated 32 bit value into a given 
		register*/
	li t0, 0
	li t1, 0x100	#Values can be designated in hex or decimal
	li t2, 0x000
	li a3, 0x000

	
math:
	beq t0, 50, end_m	#this will check t0 == 50 and branch to end_m if it is
	nop					# we ALWAYS need a nop (no operation) after branching and jumping instructions
	add t0, t0, 0x01	# this will add 1 to t0 and put the result back into t0
	add a0, s4, s4		# a0 = s4+s4
	add a1, s5, s5		# a1 = s5+s5
	mul a2, a0, a1		# a2 = a0 * a1
	add a3, a2, a3		# a3 = a2 + a3
	sw a3, mem_lock+0	# this will store the register value of a3 into the memory location mem_lock with an offset of zero
	b math				# this will unconditionally branch back to the math label
	nop

end_m:
	nop					# this is an infinate loop
	b end_m
	nop	

.end main				#this is where main ends
