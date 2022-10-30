  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   isMagic


@ isMagic
@ Determine whether a square 2D array of word-size values stored in memory
@   (RAM) is a magic square, where each row, column and diagonal sum to the
@   same value and the array contains the positive integers from 1 to N^2.
@
@ Parameters:
@   R0: start address of NxN square 2D array
@   R1: number of rows/columns (N)
@ Return:
@ R0 = 0 if the 2D array is not a magic square,
@ R0 = 1 if the 2D array is a magic square that is not associative,
@ R0 = 2 if the 2D array is an associative magic square.


isMagic:
  PUSH  {LR}
  
  BL findMagicNum

  BL checkRows
  CMP R2, #0
  BEQ notMagicFinal

  BL checkColumns
  CMP R2, #0
  BEQ notMagicFinal

  BL checkDiagonal
  CMP R2, #0
  BEQ notMagicFinal

  BL checkDiagonal2
  CMP R2, #0
  BEQ notMagicFinal

  BL isAssociative
  CMP R2, #0
  BEQ magicNotAssociative

  BL isAssociative2
  CMP R2, #0
  BEQ magicNotAssociative

  MOV R0, #2
  B endFinal

magicNotAssociative:
  MOV R0, #1
  B endFinal

notMagicFinal:
   MOV R0, #0

endFinal:
  POP   {PC}

@ findMagicNum
@ determine the value of the first row of numbers added togther in the 2D array of word-size values i.e magicNum
@
@ Parameters:
@   R0:  start address of NxN square 2D array
@   R1:  number of rows/columns (N)
@ 
@ Return:
@   R2: magicNum
@

findMagicNum:
  PUSH {R4-R8, LR}              

  MOV R4, R0                    @ copying parameters
  MOV R5, R1                    @ copying parameters
  MOV R6, #0                    @ count
  MOV R7, #0                    @ num

whSum:
  CMP     R6, R5                @ while (count < numOfCols)
  BHS     eWhSum                @ {
  LDR     R7, [R4, R6, LSL #2]  @  num = word[address + offset]
  ADD     R8, R8, R7            @  sum = sum + num
  ADD     R6, R6, #1            @  count = count + 1
  B       whSum                 @ }
eWhSum:                         
  MOV R2, R8                    @ copying sum into correct register

  POP  {R4-R8, PC}



@ checkRows
@ determine if the contents of each row of 2D array of word-size values sum to the same value
@
@ Parameters:
@   R0:  start address of NxN square 2D array
@   R1:  number of rows/columns (N)
@ 
@ Return:
@    R2: 0 if the each row's contents of the matrix does not sum to the same value 
@        1 each row's contents of the matrix sum to the same value
@


checkRows:
 PUSH {R4-R11, LR}              

 MOV R4, R0                      @ copying start Adr of array
 MOV R5, R1                      @ copying N (size of array)
 MOV R6, #0                      @ countCol
 MOV R9, #0                      @ countRow

 BL findMagicNum
 MOV R11, R2                     @ magicNum

loopRow:
 MOV R8, #0                      @ resetting the sum of row
 MOV R6, #0                      @ reset counter
 CMP R9, R5                      @ while (countRow < N)
 BHS  endLoopRow

loopCol:
 CMP R6, R5                      @ while (countCol < N)
 BHS endLoopCol                  @ {
 MUL R10, R9, R5  
 ADD R10, R10, R6
 LDR R7, [R4, R10, LSL #2]       @  num = word[address + offset]
 ADD R8, R8, R7                  @  sum = sum + num
 ADD R6, R6, #1                  @  countCol++
 B   loopCol                     @ }

endLoopCol:                         
 CMP R8, R11                     @ if (magicNum == sum)
 BNE notMagic
 ADD R9, R9, #1                  @ countRow++
 B   loopRow

notMagic:
 MOV R2, #0                      @ 0 = row sums are not equal
 B   endCheckRows

endLoopRow:
 MOV R2, #1                      @ 1 = row sums are equal

endCheckRows:
 POP  {R4-R11, PC}


@ checkColumns
@ determine if the contents of each column of 2D array of word-size values sum to the same value
@
@ Parameters:
@   R0:  start address of NxN square 2D array
@   R1:  number of rows/columns (N)
@ 
@ Return:
@   R2: 0 if the each column's contents of the matrix does not sum to the same value 
@       1 each column's contents of the matrix sum to the same value
@


checkColumns:
 PUSH {R4-R11, LR} 

 MOV R4, R0                      @ copying start Adr of array
 MOV R5, R1                      @ copying N (size of array)
 MOV R6, #0                      @ countCol
 MOV R9, #0                      @ countRow

 BL findMagicNum
 MOV R11, R2                     @ magicNum

loopCol2:
 MOV R8, #0                      @ resetting the sum of col
 MOV R6, #0                      @ reset counter of col
 CMP R9, R5                      @ while (countRow < N)
 BHS endLoopCol2

loopRow2:
 CMP R9, R5                      @ while (countRow < N)
 BHS endLoopRow2                 @ {
 MUL R10, R9, R5  
 ADD R10, R10, R6
 LDR R7, [R4, R10, LSL #2]       @  num = word[address + offset]
 ADD R8, R8, R7                  @  sum = sum + num
 ADD R9, R9, #1                  @  countRow++
 B   loopRow2                    @ }

endLoopRow2:                         
 CMP R8, R11                     @ if(sum == magicNum)
 BNE notMagic2
 ADD R6, R6, #1                  @ countCol++
 B   loopCol2

notMagic2:
 MOV R2, #0                      @ 0 = column sums are not equal
 B   endCheckRows2

endLoopCol2:
 MOV R2, #1                      @ 1 = column sums are equal

endCheckRows2:
  POP  {R4-R11, PC}





@ checkDiagonal
@ determine if each diagonal's contents going down the 2D array of word-size values sum to the same value
@
@ Parameters:
@   R0:  start address of NxN square 2D array
@   R1:  number of rows/columns (N)
@ 
@ Return:
@   R2: 0 if the each diagonal's contents going down the matrix does not sum to the same value 
@       1 each diagonal's contents going down the matrix sum to the same value
@

checkDiagonal:
 PUSH {R4-R11, LR}              
 MOV R4, R0                     @ copying start Adr of array
 MOV R5, R1                     @ copying N (size of array)
 MOV R6, #0                     @ countCol
 MOV R9, #0                     @ countRow
 MOV R8, #0                     @ the sum of diag

 BL findMagicNum
 MOV R11, R2                    @ magicNum
  
loopDiag:
 CMP R9, R5                      @ while (countRow < N)
 BHS  endloopDiag
 MUL R10, R9, R5  
 ADD R10, R10, R6
 LDR R7, [R4, R10, LSL #2]      @  num = word[address + offset]
 ADD R8, R8, R7                 @  sum = sum + num
 ADD R9, R9, #1                 @  countRow++
 ADD R6, R6, #1                 @  countCol++
 B   loopDiag                   @ }

endloopDiag:                         
 CMP R8, R11                    @ if (magicNum == sum)
 BNE notMagic3
 MOV R2, #1                     @ 1 = diag sums are equal
 B   endCheckDiag

notMagic3:
 MOV R2, #0                     @ 0 = diag sums are not equal

endCheckDiag:
 POP  {R4-R11, PC}




@ checkDiagonal2
@ determine if each diagonal's contents going up the 2D array of word-size values sum to the same value
@
@ Parameters:
@   R0:  start address of NxN square 2D array
@   R1:  number of rows/columns (N)
@ 
@ Return:
@   R2: 0 if the each diagonal's contents going up the matrix does not sum to the same value 
@       1 each diagonal's contents going up the matrix sum to the same value
@

checkDiagonal2:
 PUSH {R4-R11, LR}              
 MOV R4, R0                     @ copying start Adr of array
 MOV R5, R1                     @ copying N (size of array)
 SUB R6, R5, #1                 @ countCol = N - 1
 MOV R9, #0                     @ countRow
 MOV R8, #0                     @ the sum of diag

 BL findMagicNum
 MOV R11, R2                    @ magicNum

loopDiag2:
 CMP R9, R5                     @ while (countRow < N)
 BHS  endloopDiag2
 MUL R10, R9, R5  
 ADD R10, R10, R6
 LDR R7, [R4, R10, LSL #2]      @  num = word[address + offset]
 ADD R8, R8, R7                 @  sum = sum + num
 ADD R9, R9, #1                 @  countRow++
 SUB R6, R6, #1                 @  countCol--
 B   loopDiag2                  @ }

endloopDiag2:                         
 CMP R8, R11                    @ if (magicNum == sum)
 BNE notMagic4
 MOV R2, #1                     @ 1 = diag sums are equal
 B   endCheckDiag2

notMagic4:
 MOV R2, #0                     @ 0 = diag sums are not equal

endCheckDiag2:
 POP  {R4-R11, PC}


@ isAssociative:
@  determine whether a 2D array is a magic square, extend your subroutine to determine whether the 2D array is an associative magic square in terms of rows
@
@ Parameters:
@   R0:  start address of NxN square 2D array
@   R1:  number of rows/columns (N)
@ 
@ Return:
@   R2: 1 if associative in terms of rows
@       0 if not associative in terms of rows


isAssociative:
  PUSH {R4-R12, LR}              

  MOV R4, R0                          @ copying start adr 
  MOV R5, R1                          @ copying N
  MOV R6, #0                          @ row1
  MOV R7, #0                          @ col1
  SUB R8, R5, #1                      @ row2 (N-1)
  SUB R9, R5, #1                      @ col2 (N-1)
  MOV R11, #0                         @ num1
  MOV R12, #0                         @ num2
  MUL R10, R5, R5                     @ N^2 + 1
  ADD R10, R10, #1

loopAss:
  CMP     R6, R5                      @ while (row1 < N)
  BHS     endLoopAss                  @ {
  MUL     R11, R6, R5
  ADD     R11, R11, R7
  LDR     R11, [R4, R11, LSL #2]      @  num1 = word[address + offset]

  MUL     R12, R8, R5
  ADD     R12, R12, R9
  LDR     R12, [R4, R12, LSL #2]      @  num2 = word[address + offset]

  ADD     R12, R12, R11               @  sum = num1 + num2
  CMP     R12, R10
  BNE     notAss
  ADD     R6, R6, #1                  @  row1++
  SUB     R8, R8, #1                  @  row--
  B       loopAss                     @ }
  
endLoopAss:
  MOV R2, #1                          @ 1 = ASS sums are equal
  B endAss

notAss:
  MOV R2, #0                          @ 0 = ASS sums are not equal

endAss:
  POP  {R4-R12, PC}




@ isAssociative:
@  determine whether a 2D array is a magic square, extend your subroutine to determine whether the 2D array is an associative magic square in terms of columns
@
@ Parameters:
@   R0:  start address of NxN square 2D array
@   R1:  number of rows/columns (N)
@ 
@ Return:
@   R2: 1 if associative in terms of columns
@       0 if not associative in terms of columns

isAssociative2:
  PUSH {R4-R12, LR}              

  MOV R4, R0                         @ copying start adr 
  MOV R5, R1                         @ copying N
  MOV R6, #0                         @ row1
  MOV R7, #0                         @ col1
  SUB R8, R5, #1                     @ row2 (N-1)
  SUB R9, R5, #1                     @ col2 (N-1)
  MOV R11, #0                        @ num1
  MOV R12, #0                        @ num2
  MUL R10, R5, R5                    @ N^2 + 1
  ADD R10, R10, #1

loopAss2:
  CMP     R7, R5                     @ while (col1 < N)
  BHS     endLoopAss2                @ {
  MUL     R11, R6, R5
  ADD     R11, R11, R7
  LDR     R11, [R4, R11, LSL #2]     @  num1 = word[address + offset]

  MUL     R12, R8, R5
  ADD     R12, R12, R9
  LDR     R12, [R4, R12, LSL #2]     @  num2 = word[address + offset]

  ADD     R12, R12, R11              @  sum = num1 + num2
  CMP     R12, R10
  BNE     notAss2
  ADD     R7, R7, #1                 @  col++
  SUB     R9, R9, #1                 @  col--
  B       loopAss2                   @ }

endLoopAss2:
  MOV R2, #1                         @ 1 = ASS sums are equal
  B endAss2

notAss2:
  MOV R2, #0                         @ 0 = ASS sums are not equal

endAss2:
  POP  {R4-R12, PC}








.end