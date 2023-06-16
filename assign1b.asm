//assign1b.asm
//Daniel Park
//30144081
//Tutorial T05 - Lecture 02
//This is the reponse to the second question from assignment 1. code is meant to compute the y value for -10 <= x <= 10 for y = -4x^4 + 301x^2 + 56x - 103.
//This file utilizes various macros in the form of define() for registers and uses the madd instruction in addition to the original mov, mul, and add instructions
//Uses a post-test look with the check at the bottom of the loop. macros specified for heavily used registers. Optimized for increased readability and efficency


//fmt
fmt:	.string "the value of x being used is = %d, the y value calculated for this x is = %d, the maximum value of y so far is = %d\n "	//send string to printf

		
	//Main function
	.balign 4				//Align instructions to word
	.global main				//Make main function visible to outside this code

main:	stp	x29, x30, [sp, -16]!		//Save FP and LR to stack
	mov	x29, sp				//Update FP to current SP

	
	//Body of Main

	//the initializations for the names of each registry and the values that need to be assigned to them


	//Registry names
	define(x_r, x19)			//name the x value being input as x_r and put in registry x19
	define(y_r, x20)			//name the y value determined from the x value as y_r and put into registry x20
	define(max_r, x21)			//name the largest y value found so far as the max_r and put into registry x21
	
	define(x4_r, x22)			//name the registry that will store -4 for calculating -4x^4 as x4_r
	define(x301_r, x23)			//name the registry that will store 301 for calculating 301x^2 as x301_r
	define(x56_r, x24)			//name the registry that will store 56 for calculating 56x as x56_r
	define(ysum_1,x25)			//storage for calculated value of -4x^4
	define(ysum_2,x26)			//storage for calculated value of 301x^2+ -4x^4
	define(ysum_3,x27)			//storage for -4X^4 + 301x^2 + 56x
	define(ysum_f, x28)			//storage for the final value of the y value evaluated in the calculation
	
	//Registry initializations
	mov	x_r, -10			//initialize the value of the initial x input
	mov	y_r, 0				//initialize the value of the inital y value of the calculation as zero since not yet initialized
	mov	max_r, 0			//initialize the maximum y value found across functions as 0 since it is 
	mov	ysum_1, 0			//initialize the value of -4x^4 as zero since not yet defined
	mov	ysum_2, 0			//initialize the value of -4x^4 + 301x^2 as zero since not yet defined
	mov	ysum_3, 0			//initialize the value of -4x^4 + 301x^2 + 56x as zero since not yet defined
	mov	x4_r, -4			//-4 in named registry for calculations as mul
	mov	x301_r, 301			//301 in named registry for calculations as mul
	mov 	x56_r, 56			//56 in named registry for calculations as mul
	
	
	//the Loop - calculates y value from given x

calc:	mov	ysum_f, 0			//the final y value from calculating using x is initialized as 0. Placed here as used alone in code once.

	mul 	ysum_1, x_r, x_r		//the operation of ysum_1 = x^2
	mul	ysum_1, ysum_1, x_r		//the operation of ysum_1 = x^3
	mul	ysum_1, ysum_1, x_r		//the operation of ysum_1 = x^4
	mul 	ysum_1, ysum_1, x4_r		//finally, the operation which makes ysum_1 = -4x^4
	
	mul 	ysum_2, x_r, x_r		//the operation of ysum_1 = x^2
	madd	ysum_2, ysum_2, x301_r, ysum_1	//multiplies 301 to x and adds ysum_1 so ysum_2 = -4x^4 + 301x^2
		
	madd	ysum_3, x56_r, x_r, ysum_2	 //mutliplies x by 56 then adds ysum_2 to get ysum_3 = -4x^4 + 301x^2 + 56x
		
	add	ysum_f, ysum_f, -103		//subtracts 104 from the final y value so ysum_f = -103 
	add	ysum_f, ysum_f, ysum_3		//adds the above to ysum_3 so that ysum_f = -4x^4 + 301x^2 + 56x -103
	

	//check for invalid values of x and program end cases

	cmp	x_r, -10			//if x is less than -10, then it is an invalid input/test
	b.lt	exit				//calls function to end the run
		
	cmp	x_r, 10				//if x is more than 10, then it is an invalid input/test
	b.gt	exit				//calls function to end the run
	

	//updating the maximum y value and its initialization

	cmp	x_r, -10			//if the x value is the very first value, -10, then assign its y value to the largest y value so far
	b.eq	change				//calls function to update the largest(max) y value
	
	cmp	ysum_f, max_r			//if the final y value calculated from c is larger than the current largest y value
	b.gt	change				//calls function to update the largest(max) y value
	b.lt	print				//if the final y value  from x is NOT larger than the current largest y value, move right to function print stats

	//change the maximum y value to the y value computed for the current x

change:	mov	max_r, ysum_f			//assign the y value calculated from the current x to the largest y value found so far
	b	print				//call function to print stats

	//print the stats of the tests
print:	ldr	x0, =fmt			//format for print
	mov	x1, x_r				//print data one = the value of x
	mov	x2, ysum_f			//print data two = the value of the y value calculated from the current x
	mov	x3, max_r			//print data three = the value of the current largest(max) y value
	bl	printf				//print
	add	x_r, x_r, 1			//increment the value of the x by 1
	b	calc				//call to the start of loop (calc)
	
	//return 0
exit:	
	mov	x0, 0				//Return value 0 is stored in x0
	ldp	x29, x30, [sp], 16		//Restore FP and LR from stack pointer
	ret					//Go back to the Callee
