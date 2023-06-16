//assign1a.s
//Daniel Park
//30144081
//Tutorial T05 - Lecture 02
//Assignment 1 - File 1
//This file is the "first file" meant to answer to question 1 of assignment 1. prints the y values with -10 <= x <= 10 where y = -4x^4 + 301x^2 + 56x - 103. 
//This file does not contain any macros. Utilizes a pre-test loop with the test at top to compute each y value for each x value. only mul, add and mov instructions used//no m4 used

//fmt
fmt:    .string "With the input x = %d, the corresponding value of y is = %d, the maximum y value currently is = %d \n"	//String to send to printf

	//main function
	.balign 4					//Align Instructions to word
	.global main					//Make main function visible to outside this code


main:	stp	x29, x30, [sp, -16]!			// Save FP and LR to stack
	mov 	x29, sp					// Update FP to current SP
	
	//Body of the main function

	//Initializations for the loop on calculating the y val from the x val

	mov 	x19, -10				//Initialize the x variable value to be tested
	mov	x20, 0					//the y value returned by running the given x value through -4x^2+301x^2+56x-103
	mov	x21, 0					//the maximum y value so far from the x values computed
	

	mov	x22, -4					//the coefficient in front of the X^4- used due to the fact that mul can only accept registries
	mov	x23, 301				//the coefficient in front of the x^2 - used due to the fact that mul can only accept registries
	mov	x24, 56					//the coefficient in front of the x - used due to the fact that mul can only accept registries
	
	//Loop - this calculates the value of the y using the x given

calc:	cmp	x19, -10				//the x value that is used in this calculation cannot be lower than -10
	b.lt	exit					//end the code- since invalid x value is present
	
	cmp	x19, 10					//the x value that is used in this calculation cannot be higher than 10
	b.gt	exit					//end the code - since invalid x value is present

		

	mov	x25, x19				//local registry designed for the x^4 section when calculation -4x^4
	mov	x26, x19				//local registry designed for the x^2 section when calculation -301x^2
	mov	x27, x19				//local registry designed for the x section when calculation 56x
	
	mul	x25, x25, x22				//multiply x by -4 and store it in x25
	mul	x25, x25, x26				//multiply x25(which is now -4x) by x
	mul	x25, x25, x26				//multiply x25(which is now -4x^2) by x
	mul	x25, x25, x26				//multiply x25(which is now -4x^3) by x			we have now calculated -4x^4

	mul	x26, x26, x26				//multiply x by x and store it in x26
	mul	x26, x26, x23				//multiply x26(now x^2) by 301 				we have now calculated 301x^2

	mul	x27, x27, x24				//multiply x by 56					we now have 56x
		
	add	x20, x25, x26				//add -4x^4 and 301x^2 and store to x26
	add	x20, x20, x27				//add 56x to x26 which is now (-4x^4 + 301x^2)
	add	x20, x20, -103				//add -103 to x26 which is now (-4x^4 + 301x^2 + 56x)	we have now calculated  -4x^4+301x^2+56x-103
	
	
	//program end conditions and error conditions

	cmp	x19, -10				//if x =-10, which is the first value to test, there is no previous largest maximum to compare to
	b.eq	change					//call the function to set this first value as the largest y value or maximum 
	
	cmp	x20, x21				//if the y value of the x value for this iteration is larger than the recorded maximum, switch it out for that
	b.gt	change					//call the function to set this new y value as the new maximum
	b.lt	print					//if no change is needed to the maximum value- print right away

	//Function to change the maximum y

change:	mov x21, x20					//if the new y value is larger than the maximum recorded so far
	b	print					//call the function to print stats immediately 

	//print function
			
print:	ldr	x0, =fmt				//Format setup for printing
	mov	x1, x19					//assign x1 the same value as the x value
	mov	x2, x20					//assign x2 the same value as the y value returned currently
	mov	x3, x21					//assign x3 the largest y value found so far
	bl	printf					//print the above three
	add	x19, x19, 1				//increment the value of x by 1
	b	calc					//return to the start of the loop to calculate the y for the new x


exit:	//return 0
	mov	 x0, 0					//Return value 0 is stored in x0
	ldp	 x29, x30, [sp], 16			//Restore FP and LR from stack pointer 	
	ret						//Go back to the Callee
