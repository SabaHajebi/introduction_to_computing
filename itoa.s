  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Follow the instructions in the handout for Assignment 5

  @
  @ TIP: To view memory when debugging your program you can ...
  @
  @   Add the watch expression to see individual characters: (char[64])strA
  @
  @   OR
  @
  @   Add the watch expression to see the string: (char*)&strA
  @
  @   OR
  @
  @   Open a 'Memory View' specifying the address &strA and length at
  @   least 11. You can open a Memory View with ctrl-shift-p type
  @   'View Memory' (cmd-shift-p on a Mac).
  @

  MOV R5, #10
  MOV R6, #1
  MOV R10, #0

dealWithSign:             @ while { 
  CMP R1, #0              @ number > 0 
  BLT neg                 
  BEQ zero
  MOV R7, '+'
  STR R7, [R0]
  B intToAscii

 zero:
   MOV R4, '0'
   STR R4, [R0]
   B intToAscii

  neg:
   MOV R11, '-'
   STR R11, [R0]
   SUB R12, R10, R6
   MUL R1, R1, R12
   B intToAscii
  
intToAscii:
  ADD R0, R0, #1          @ incerementing 
  MOV R2, R1              @ save R1 as we need it later
  MOV R8, #0              @ R8 for the reversed number

whileReverse:             @ while {
  CMP R2, #0              @ number < 0
  BEQ endWhileReverse
  
   UDIV R4, R2, R5          @ 356 / 10 = 35
   MUL R6, R4, R5           @ 35 * 10 = 350
   SUB R9, R2, R6           @ 365 - 350 = 5
   MUL R8, R8, R5
   ADD R8, R9
   MOV R2, R4
  
  B whileReverse           @ }

endWhileReverse: 
  MOV R1, R8

  while:                   @ while {
   CMP  R1, #0             @ number > 0
   BEQ endWhile

   UDIV R2, R1, R5          @ 356 / 10 = 35
   MUL R3, R2, R5           @ 35 * 10 = 350
   SUB R4, R1, R3           @ 365 - 350 = 5
   ADD R4, #48              @ 5 + 48 = 53 converting integer to ascii
   STR R4, [R0]          
   MOV R1, R2               @ replacing 356 with 35
   ADD R0, R0, #1           @ incrementing 

   B while

  endWhile:                 @ }
 STR R10, [R0]              @ null termminating string 
  
  @ End of program ... check your result


End_Main:
  BX    lr
