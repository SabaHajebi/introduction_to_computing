  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Write an ARM Assembly Language program to evaluate
  @   ax^2 + bx + c for given values of a, b, c and x

MUL R0, R1, R1
MUL R0, R0, R2

MUL R5, R3, R1
ADD R0, R0, R5

ADD R0, R0, R4
  

  @ End of program ... check your result

End_Main:
  BX    lr
