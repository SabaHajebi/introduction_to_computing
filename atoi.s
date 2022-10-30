  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Follow the instructions in the handout for Assignment 2

  MOV R6, #48
  SUB R1, R1, R6
  SUB R2, R2, R6
  SUB R3, R3, R6
  SUB R4, R4, R6

  MUL R0, R4, R5
  ADD R0, R0, R3
  MUL R0, R0, R5
  ADD R0, R0, R2
  MUL R0, R0, R5
  ADD R0, R0, R1

  @ End of program ... check your result

End_Main:
  BX    lr
