  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   fp_add

@ fp_add subroutine
@ Add two IEEE-754 floating point numbers
@
@ Paramaters:
@   R0: a - first number
@   R1: b - second number
@
@ Return:
@   R0: result - a+b
@


fp_add:
  PUSH    {R4-R11, LR}    
                  
  MOV R10, R0                  @ add any registers R4...R12 that you use
  BL fp_frac
  MOV R4, R0                       @ fraction of A

  MOv R0, R10
  BL fp_exp
  MOV R5, R0                        @ exponent of A

  MOV R11, R1
  MOV R0, R11
  BL fp_frac
  MOV R6, R0                        @ fraction of B

  MOV R0, R11
  BL fp_exp
  MOV R7, R0                        @ exponent of B
 

 Alignment:
  CMP R7, R5                        @ if (expB < expA)
  BGE B_MoreThan_A
  SUB R8, R5, R7                    @ obtain the difference
  LSR R6, R6, R8                    @ the fraction of B right by the difference
  MOV R1, R5  
  B endAllignment

B_MoreThan_A:
  SUB R8, R7, R5                    @ obtain the difference
  LSR R4, R4, R8 
  MOV R1, R7 

endAllignment:
  ADD  R0, R4, R6                   @ adding fractions 
  BL   fp_enc                       @ normalise

  POP     {R4-R11, PC}                      @ add any registers R4...R12 that you use


@
@ Copy your fp_frac, fp_exp, fp_enc subroutines from Assignment #6 here
@   and call them from fp_add above.
@


@ fp_frac subroutine
@ Obtain the fraction of an IEEE-754 (single precision) number.
@
@ The returned fraction will include the 'hidden' bit to the left
@   of the radix point (at bit 23). The radix point should be considered to be
@   between bits 22 and 23.
@
@ The returned fraction will be in 2's complement form, reflecting the sign
@   (sign bit) of the original IEEE-754 number.
@
@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: fraction (signed fraction, including the 'hidden' bit, in 2's
@         complement form)

fp_frac:

  PUSH    {R4-R8, LR}                      @ add any registers R4...R12 that you use
  MOV  R7, #1
  MOV   R4, R0
  MOV R5, R0, LSR #31                      @ storing sign in R5

  MOV 	R4, R4, LSL #9	                   @ clearing bit 0-9
	MOV 	R4, R4, LSR #9

  ADD R4, R4, #0x00800000                  @ adding 1 to left of radix point
  CMP R5, R7
  BNE	End
	LDR R8, =0xFFFFFFFF			      
	EOR	R4, R4, R8		
  ADD	R4, R4, #1	
  MOV R0, R4

End: 
  MOV R0, R4
  POP     {R4-R8, PC}                      @ add any registers R4...R12 that you use


@ fp_exp subroutine
@ Obtain the exponent of an IEEE-754 (single precision) number as a signed
@   integer (2's complement)
@
@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: exponent (signed integer using 2's complement)

fp_exp:
  PUSH    {R4, R5, LR}                      @ add any registers R4...R12 that you use
 
  LDR	R4, =0x807FFFFF		
  BIC R5, R0, R4
  LSR R5, R5, #23
  SUB R5, R5, #127
  MOV R0, R5

  POP     {R4, R5, PC}                      @ add any registers R4...R12 that you use



@ fp_enc subroutine
@ Encode an IEEE-754 (single precision) floating point number given the
@   fraction (in 2's complement form) and the exponent (also in 2's
@   complement form).
@
@ Fractions that are not normalised will be normalised by the subroutine,
@   with a corresponding adjustment made to the exponent.
@
@ Parameters:
@   R0: fraction (in 2's complement form)
@   R1: exponent (in 2's complement form)
@
@ Return:
@   R0: IEEE-754 single precision floating point number
fp_enc:
  PUSH	{R4-R9, LR}
  MOV R8, #8
  MOV R9, #0                        @  r9 = sign
	
  CMP R0, #0	                     @	 Check if fraction is negative
  BGT	endif2					
	NEG	R0, R0	
  MOV R9, #1

		                              
endif2:

CLZ R6, R0

while:
 CMP R6, #8        @ while (lz != 8)
 BEQ endWhile
 CMP R6, #8
 BLT lessThan8     @ if (lz < 8)
 CMP R6, #8
 BGT shiftRight    @ if (lz > 8)

lessThan8:
 SUB R7, R8, R6         @ 8 - lz
 MOV R0, R0, LSR R7                   
 ADD R1, R1, R7
 B endWhile

shiftRight:
 SUB R7, R6, #8         
 MOV R0, R0, LSL R7
 ADD R1, R1, R7
 B endWhile

endWhile:

@ Putting it all together
@Add the bias (127) to the exponent, move the exponent into the correct bit position, 
@combine into the final IEEE-754
@Remove the hidden 1 from the fraction, combine the fraction into the final IEEE-754
				
	ADDS R1, R1, #127		  @add the bias (127) to the exponent,
	LSL	R1, R1, #24				@ move the exponent into the correct bit position
  LSR R1, R1, #1
  LSL R9, R9, #31 	    @ shifting by 31 tp create the sign bit	
  ORR R9, R9, R1
  LSL R0, R0, #10
  LSR R0, R0, #10
  ORR R0, R9, R0


	POP	{R4-R9, PC}



.end