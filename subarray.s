  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @ R0: Address of A; R1: M (size of A)
  @ R2: Address of B; R3: N (size of B)
  @ write your program here
  @
  SUB R9, R1, R3                       @ M - N
  MOV R4, #0                           @ x 
  MOV R5, #0                           @ y

RowBigMat:
  CMP R4, R9                           @ while (x < (M - N))
  BEQ NotFoundMatch

ColBigMat:
  CMP R5, R9                           @ while (y <= (M - N))
  BHI EndBigColMat
  
  MUL R8, R1, R4                       @ S: Staring address of the subarray with respect to R0, x, y
  MOV R11, #4
  MUL R8, R8, R11
  MUL R10, R5, R11 
  ADD R8, R8, R10                      @ Resuing R10; but it's ok 
  ADD R8, R8, R0

  MOV R6, #0                           @ p: rows of subarray & B
  MOV R7, #0                           @ q: cols of subarray & B

RowSmallMat:
  CMP R6, R3                           @ p compare to N
  BEQ FoundMatch

ColSmallMat:
  CMP R7, R3                           @ q compare to N
  BEQ EndColSmallMat
  @ Calc S with respect to A, x, y (already done saved in R8)
  @ R12: Calc offset with respect to p, q; add it to S and B; then compare contents

  @ Load values into registers
  MUL R12, R6, R1
  ADD R12, R12, R7
  LDR R10, [R8, R12, LSL #2]                   @ Cells in subarray of A
  MUL R12, R6, R3
  ADD R12, R12, R7
  LDR R11, [R2, R12, LSL #2]                   @ Cells in B    
  CMP R10, R11
  BNE NotMatchInCurrSubarray
  ADD R7, R7, #1                      @ Increment col counter of subarray & B
  B   ColSmallMat

EndColSmallMat:
  ADD R6, R6, #1                      @ Increment p (row counter)
  MOV R7, #0                          @ Reset q (col counter)
  B   RowSmallMat

NotMatchInCurrSubarray:
  ADD R5, R5, #1                     @ Increment col counter for A
  B   ColBigMat

EndBigColMat:
  ADD R4, R4, #1                     @ Increment row counter for A
  MOV R5, #0
  B   RowBigMat

FoundMatch:
  MOV R0, #1
  B   End_Main

NotFoundMatch:
  MOV R0, #0
  B   End_Main

  @ End of program ... check your result

End_Main:
  BX    lr

