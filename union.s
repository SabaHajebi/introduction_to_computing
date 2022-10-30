  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Follow the instructions in the handout for Assignment 6

  @
  @ TIP: To view the contents of setC while debugging, you can add
  @      the following watch expression, remembering that the first value
  @      listed should be the size of setC and the remaining values shown
  @      should be the values in the set in memory.
  @
  @      (int [64])setC
  @

  
  
  LDR   R3, [R1]      @ sizeA = word[adrA]
  LDR   R11, [R2]     @ sizeB = word[adrB]
  ADD   R1, R1, #4    @ adrA += 4
  ADD   R7, R0, #4    @ tmpAdrC = adrC + 4 // leave space for size
  MOV   R4, #0        @ sizeC = 0
  MOV   R5, #0        @ countSizeB = 0

WhCpyA:
  CMP   R5, R3        @ while (count < sizeA)
  BHS   EndWhCpyA     @ {
  LDR   R6, [R1]      @   elem = word[adrA]
  STR   R6, [R7]      @   word[adrC] = elem
  ADD   R7, R7, #4    @   adrC += 4
  ADD   R4, R4, #1    @   sizeC++
  ADD   R1, R1, #4    @   adrA += 4
  ADD   R5, R5, #1    @   count++
  B     WhCpyA        @ }
EndWhCpyA:

  MOV   R5, #0        @ count = 0
WhCpyB:
  CMP   R5, R11       @ while (count < sizeB)
  BHS   EndWhCpyB     @ {
  ADD   R2, R2, #4    @   adrB += 4
  LDR   R6, [R2]      @   elemB = word[adrB]
  ADD   R1, R0, #4    @   adrC += 4

WhCkC:
  CMP   R1, R7        @ while (adrB <= adrC)
  BEQ   NotFoundInC   @ {
  LDR   R8, [R1]      @  elemC = word[adrB]
  CMP   R6, R8        @  if (elemB != elemC)
  BEQ   FoundInC      @   {
  ADD   R1, R1, #4    @     adrC += 4
  B WhCkC             @   }


FoundInC:
  ADD R6, R6, #4      @ elemB += 4
  ADD R5, R5, #1      @ count ++
  B WhCpyB
  
NotFoundInC:
  STR R6, [R7]        @ word[adrC] = elemB
  ADD R7, R7, #4      @ adrC += 4
  ADD R5, R5, #1      @ count++
  B WhCpyB

EndWhCpyB:

  SUB R9, R7, R0      @ tmpResult = result - adrC
  MOV R10, #4         
  UDIV R9, R9, R10    @ tmpResult = tmpResult / 4
  SUB  R9, R9, #1     @ tmpResult = tmpResult - 1
  STR  R9, [R0]       @ result = tmpResult



  