  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

@
@ Follow the instructions contained in the examination paper
@

MOV R0, #0                    @ Value so far
MOV R5, '+'                   @ Current operator
MOV R3, #0                    @ current number
MOV R10, #10

mainWhile: 
  LDR R2, [R1]                @ current character == mainAdr
  ADD R1, R1, #1              @ mainAdr++
  CMP R2, #0                  @ if (current character < 0)
  BEQ applyOperator           @ {

innerWhile:       
  CMP R2, #0x30               @ if (current character >=  #0x30 )
  BLO readOperator            @ {

makeNum:
  MUL R3, R3, R10             @ current number = current number * 10
  SUB R2, R2, #0x30           @ current character = current character -  #0x30 
  ADD R3, R3, R2              @ current number = current number + current character 
  B mainWhile

readOperator:
  B applyOperator
setNextOp:
  CMP R2, #0                  @ if (current character < 0)
  BEQ end                     @ { 
  MOV R5, R2                  @   Current operator = current character
  B mainWhile

applyOperator: 
  CMP R5, '+'                 @ if (Current operator != '+')
  BEQ plus                    @ {
  CMP R5, '-'                 @ if (Current operator != '-')
  BEQ subtract                @ {
  CMP R5, '*'                 @ if (Current operator != '*')
  BEQ multiply                @ {
  CMP R5, '/'                 @ if (Current operator != '/')
  BEQ divide                  @ {

plus:
  ADD R0, R0, R3              @ Value so far = Value so far + current number
  MOV R3, #0                  @ current number == 0
  B setNextOp
subtract:
  SUB R0, R0, R3              @ Value so far = Value so far + current number
  MOV R3, #0                  @ current number == 0 
  B setNextOp
multiply:
  MUL R0, R0, R3              @ Value so far = Value so far + current number
  MOV R3, #0                  @ current number == 0 
  B setNextOp
divide:
  UDIV R0, R0, R3             @ Value so far = Value so far + current number
  MOV R3, #0                  @ current number == 0 
  B setNextOp


end:


End_Main:
  BX    lr
