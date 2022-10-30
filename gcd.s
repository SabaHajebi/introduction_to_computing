  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Follow the instructions in the handout for Assignment 3

@ R2 = a, R3 = b
 While:
  CMP R2, R3
  BEQ EndWhile      @ while (R2 != R3){
 
 IF:                
  CMP R2, R3        @ if (R2>R3){
  BLE Else
  SUB R2, R2, R3    @ a=a-b;
  B While

Else:               @ }else{
  SUB R3, R3, R2    @ b=b-a;
  B While           @}

EndWhile:           @}
  MOV R0, R2








     


  @ End of program ... check your result

End_Main:
  BX    lr
