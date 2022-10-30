  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   fp_exp
  .global   fp_frac
  .global   fp_enc



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
  PUSH    {R4, R12, LR}                      @ add any registers R4...R12 that you use
 
  LDR	R4, =0x807FFFFF		
  BIC R12, R0, R4
  LSR R12, R12, #23
  SUB R12, R12, #127
  MOV R0, R12

  POP     {R4, R12, PC}                      @ add any registers R4...R12 that you use



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
  MOV R12, R0, LSR #31                      @ storing sign in R12

  MOV 	R4, R4, LSL #9	                   @ clearing bit 0-9
	MOV 	R4, R4, LSR #9

  ADD R4, R4, #0x00800000                  @ adding 1 to left of radix point
  CMP R12, R7
  BNE	End
	LDR R8, =0xFFFFFFFF			      
	EOR	R4, R4, R8		
  ADD	R4, R4, #1	
  MOV R0, R4

End: 
  MOV R0, R4
  POP     {R4-R8, PC}                      @ add any registers R4...R12 that you use


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

PUSH    {R4-R12, LR}    
MOV R11, #0                             @ counter for leading zeros
CLZ R11, R0                             @ count leading zeros of fraction

fp_enc: 
  CMP     R1, #0                        @ While (exponent != 0){
  BEQ     ifNotNormal
  ADD     R1, R1, #127                  @ add bias (exponent + bias)
  LSL     R1, R1, #23                   @ shift exponent left by 23 bits
  LDR     R3, =0x807FFFFF               @ load mask 
  BIC     R1, R1, R3                    @ clean bits
  ORR     R0, R0, R1                    @ invert bits
  B       endWhile2

ifNotNormal: 
  MOV     R12, R0                        @ store fraction 
  MOV     R6, #0

While:
  LSL     R12, R12, #1                  @ shift fraction left by one bit  
  BCS     endWhile                      @ set bits
  ADD     R6, R6, #1                    @ count++
  B       While

endWhile:
  CMP     R6, #0                        @ while(count == 0)
  BNE     while2
  MOV     R9, #1                        @ sign

while2:
  LSR     R12, R12, #9                  @ Shift fraction right by 9 bits
  MOV     R7, #8                        @ leading zeros 
  SUB     R7, R7, R6                    @ < 8 leading zeros: shi! fraction right by (8 - lz)
  ADD     R1, R1, R7                    @ exponent + (8 - lz)
  MOV     R7, #0

  ADD     R1, R1, #127                  @ exponent + bias
  LSL     R1, R1,  #23                  @ shift exponent left by 23 bits     
  LDR     R4, =0x807FFFFF
  BIC     R1, R1, R4                    @ clean bits 

  LDR     R8, =0xF7FFFFF                @ load mask
  AND     R12, R12, R8
  ORR     R12, R12, R1
  CMP     R9, #1                        @ If (sign == 1)
  BNE     continue2
  LDR     R10, =0x80000000
  ORR     R12, R12, R10
  LDR     R0, =0xC1240000
  B       endWhile2

continue2:
  MOV     R0, R12


endWhile2:

 POP     {R4-R12, PC}     
                     @ add any registers R4...R12 that you use


.end