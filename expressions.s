  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @

  @
  @ You can use either
  @
  @   The System stack (R13/SP) with PUSH and POP operations
  @
  @   or
  @
  @   A user stack (R12 has been initialised for this purpose)
  @

  MOV R3, #0                       @ number  == 0
  MOV R5, #10                      @ multiple == 10
  MOV R6, #0                       @ isNumber == false

WhileNotNull: 
  LDRB R2, [R1]                    @ first value of string (value)
  CMP R2, #0                       @ while(value != 0)
  BEQ EndWhile

  CMP R2, #0x39                    @ if (value > 9)
  BHI doNothongJustPass
  
  CMP R2, #0x20                    @ if (value == space)
  BEQ dealWithSpace

  CMP R2, #0x30                    @ if (value < 0)
  BLO handleOperators

dealWithNum:
  CMP R6, #0                       @ if (isNumber = true)
  BEQ noNumberBefore               
  MUL R3, R3, R5                   @ number = number * 10
  B   makeNumner

noNumberBefore:
  MOV R3, #0                       @ number == 0
  MOV R6, #1                       @ isNumber == true
makeNumner: 
  SUB R2, R2, #48                  @ turning ASCII into decimal value (x)
  ADD R3, R3, R2                   @ number = number + newNumber
  ADD R1, R1, #1                   @ memoryAdr++
  B WhileNotNull

dealWithSpace:
  CMP R6, #0                       @ if (isNumber == true)
  ADD R1, R1, #1                   @ meomoryAdr++
  BEQ WhileNotNull                 
  STMDB SP!, {R3}                  @ PUSH number onto stack
  MOV R6, #0                       @ isNumber == false
  B WhileNotNull

handleOperators:
  LDMIA SP!, {R7}                  @ POP value off stack
  LDMIA SP!, {R8}                  @ POP next value off stack

  CMP R2, #0x2B                    @ if (value == '+')
  BEQ applyAddition

  CMP R2, #0x2D                    @ if (value == '-')
  BEQ applySubtraction    

  CMP R2, #0x2A                    @ if (value == '*')
  BEQ applyMultiplication

applyAddition:
  ADD R9, R8, R7                  @ finalNum = num1 + num2
  STMDB SP!, {R9}                 @ PUSH finalNum
  ADD R1, R1, #1                  @ memoryAdr++
  B WhileNotNull
  
applySubtraction:
  SUB R9, R8, R7                  @ finalNum = num1 - num2
  STMDB SP!, {R9}                 @ PUSH finalNum
  ADD R1, R1, #1                  @ memoryAdr++
  B WhileNotNull

applyMultiplication:
  MUL R9, R8, R7                  @ finalNum = num1 * num2
  STMDB SP!, {R9}                 @ PUSH finalNum  
  ADD R1, R1, #1                  @ memoryAdr++
  B WhileNotNull

doNothongJustPass:
  ADD R1, R1, #1                  @ memoryAdr++
  B WhileNotNull

EndWhile:
 LDMIA SP!, {R0}                 @ PUSH finalNum  

  










  @ End of program ... check your result

End_Main:
  BX    lr

