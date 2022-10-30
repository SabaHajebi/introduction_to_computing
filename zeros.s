  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Follow the instructions in the handout for Assignment 8

  @ R1 = where digit is stored
  @ R0 = max so far
  @ R2 = temp count of 0s
  
  MOV R2, #0               
  MOV R3, #32

whileUntilZero:
    CMP R3, #0
    BEQ endWhileUntilZero
    SUB R3, R3, #1
    MOVS R1, R1, LSR #1
    BCS reachedOne
    ADD R2, R2, #1
    B whileUntilZero

reachedOne:
  CMP R2, R0
  BLO currentCountLower
  MOV R0, R2
  MOV R2, #0
  B whileUntilZero
  
currentCountLower:
  MOV R2, #0
  B whileUntilZero

endWhileUntilZero:
  CMP R2, R0
  BLO end
  MOV R0, R2

end: 


  @ End of program ... check your result

End_Main:
  BX    lr
