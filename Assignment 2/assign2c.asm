//assign2c.asm
//Daniel Park
//Tutorial T05 - Lecture 02
//CPSC 355 Fall
//Assignment 2 - file 3
//30144081


//fmt (for text)
fmt:								//format function

	.string "original: 0x%08X	reversed: 0x%08X\n"	//String to send to printf
		
	//Main Function
	.balign 4						//Align instructions to word
	.global main						//make main function visible to outside this code

//main 
main:								//main function

	stp	x29, x30, [sp, -16]!				// Save FP and LR to stack
	mov	x29, sp						// Update FP to current SP

	//initializse naming for the variables
	define(x, w19)						//variable x is in registry w19	
	define(y, w20)						//variable y is in registry w20
	define(t1, w21)						//variable t1 is in registry w21
	define(t2, w22)						//variable t2 is in registry w22
	define(t3, w23)						//variable t3 is in registry w23
	define(t4, w24)						//variable t4 is in registry w24
	
	//initialize variable		
	mov	x, 0x01FF01FF					//variable x is initialized
	
	//Reverse bits in the variable
	//Step 1		
	and	t1, x, 0x55555555				//do the step for (x & 0x55555555) and store in t1
	lsl	t1, t1, 1					//do the step for (x & 0x55555555) << 1 and assign this to t1 finally (shift t1 1 left)
	lsr	t2, x, 1					//do the step for x >> 1 and store in t2 (shift x 1 right)
	and	t2, t2, 0x55555555				//do the step for (x >> 1) & 0x55555555 and assign to t2 finally
	orr	y, t1, t2					// do t1 | t2 using OR and update y to it
	

	//Step 2
	and	t1, y, 0x33333333				//do the step for (y & 0x33333333) and store in t1
	lsl	t1, t1, 2					//do the step for (y & 0x33333333) << 2 and assign this to t1 finally ( shift t1 2 left)
	lsr	t2, y, 2					//do the step for y >> 2 and store in t2 (shift y  2 right)
	and	t2, t2, 0x33333333				//do the step for (y >> 2) & 0x33333333 and assign this to t2 finally
	orr	y, t1, t2					// do t1 | t2 using OR and update y to it

	//Step 3
	and	t1, y, 0x0F0F0F0F				//do the step for (y & 0x0F0F0F0F) and store in t1
	lsl	t1, t1, 4					//do the step for (y & 0x0F0F0F0F) << 4 and assign this to t1 finally (shift t1 4 left)
	lsr	t2, y, 4					//do the step for y >> 4 and store in t2 (shift y 4 right)
	and	t2, t2, 0x0F0F0F0F				//do the step for (y >> 4) & 0x0F0F0F0F and assign this to t2 finally
	orr	y, t1, t2					// do t1 | t2 using OR and update y to it	

	//Step 4
	lsl	t1, y, 24					//do y << 24 (shifts y 24 left) and stores in t1
	and	t2, y, 0xFF00					//do (y & 0xFF00) and assign to t2 to use later 
	lsl	t2, t2, 8					//do t2 = (y & 0xFF00) << 8 by shifting t2 8 left and assigning it back to t2
	lsr	t3, y, 8					//do y >> 8 (shifts y 8 right) and stores in t3 for later
	and	t3, t3, 0xFF00					//do (y >> 8) & 0xFF00 = t3 and this is the final for t3
	lsr	t4, y, 24					//do t4 = y >> 24 (t4 is assigned value of y shifted 24 right)
	orr	y, t1, t2					//y = t1 | t2
	orr	y, y, t3					//y = t1 | t2 | t3
	orr	y, y, t4					//y + t1 | t2 | t3 | t4

	//print out the original and reversed variables
	ldr	x0, =fmt					//format for string
	mov	w1, x						//assign x to registry w1
	mov	w2, y						//assign y to registry w2
	bl	printf						//print x and y

	
//exit (program exit)
exit:								//exit
	//Return 0
	mov x0, 0						// Return value 0 is stored in x0
	ldp x29, x30, [sp], 16					// Return FP and LR from stack pointer
	ret							// go back to the callee
