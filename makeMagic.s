  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   makeMagic


@ makeMagic
@ Generate an NxN 2D array that is a magic square, using the Siamese method.
@
@ Parameters:
@   R0: start address in memory where the magic square will be stored
@   R1: number of rows/columns (N) (must be odd)
@ Return:
@   none
makeMagic:
  PUSH    {R4-R12, LR}

  MOV R4, R0                     @ copy of start adr
  MOV R5, R1                     @ copy of N
  MOV R6, #0                     @ row
  MOV R12, #2
  UDIV R7, R5, R12               @ col
  MUL R12, R5, R5                @ N^2
  MOV R8, #1                     @ counter

while:
  CMP R8, R12                    @ while (counter < N^2)
  BEQ endWhile
  MUL R9, R6, R5                 @ index = row * row_size
  ADD R9, R9, R7                 @ index = index + col
  LDR R11, [R4, R9, LSL #2]      @ elem = word[ array + (index * elem_size) ]
  CMP R11, #0                    @ if(elem < 0)
  BGT alreadyFilled     
  STR R8, [R4, R9, LSL #2]       @ counter = word[ array + (index * elem_size) ]
  SUB R6, R6, #1                 @ row--
  CMP R6, #0                     @ if(row < 0)
  BGE rowOk
  SUB R6, R5, #1                 @ row = N - 1

rowOk:
  ADD R7, R7, #1                 @ col++
  CMP R7, R5                     @ if (col < N) 
  BLO colOk
  MOV R7, #0                     @ col = 0

colOk:
   ADD R8, R8, #1                @ counter++
   B while


alreadyFilled:
   ADD R6, R6, #1                @ row++
   B while

endWhile:   

  POP     {R4-R12, PC}

@
@ Use the following watch expression to inspect your new magic
@   square as you debug your program. Adjust dimensions [5][5] appropriately:
@
@ (int [5][5])newSquare
@


.end