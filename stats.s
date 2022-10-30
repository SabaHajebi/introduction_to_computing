  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

@
@ Follow the instructions contained in the examination paper
@

Avg:
  MOV R3, R2
  LDR R6, [R3]              @ size of set            @
  MOV R4, #0                @ counter
  MOV R7, #0                @ total 
  
  whileAvg:  
    ADD R3, R3, #4            @ mainAdr += 4
    CMP R4, R6                @ while (counter < size)
    BEQ endAvg                @ {
    LDR R5, [R3]              @  tempAdr = mainAdr
    ADD R7, R7, R5            @  total adding both values 
    ADD R4, R4, #1            @   count++
    B whileAvg                @ }

  endAvg:
  UDIV R0, R7, R6             @ storageAdr = total / size

Mode:

counts:
  .word  
  LDR R9, =counts             @ countsSpace 

  MOV R3, R2
  LDR R6, [R3]                @ size of set            
  MOV R4, #0                  @ counter of the main set
  MOV R7, #0                  @ count of unique elements
  
  whileMode:  
    ADD R3, R3, #4            @ mainAdr += 4
    CMP R4, R6                @ while (counter < size)
    BEQ endMode               @ {
    LDR R5, [R3]              @  tempAdr = mainAdr
    
    MOV R10, #0               @ counter of the new counts set
    MOV R8, #8                @ incrementer value
  AddToSet:
    CMP R10, R7               @ if (counter of the new counts set < count of unique elements)
    BEQ AddNewElements        @ {
    MUL R8, R10, R8           @  storageIncrementer = counter of the new counts set * incrementer value
    ADD R8, R8, R9            @  storageIncrementer = storageIncrementer + countsSpace
    LDR R8, [R8]              @  contentStorageIncrementer = storageIncrementer
    CMP R5, R8                @  if (tempAdr < contentStorageIncrementer)
    BEQ incrementCount        @  {
    ADD R10, R10, #1          @    counter of the new counts set++
    B AddToSet

incrementCount:         
    ADD R8, R8, #4            @ storageIncrementer += 4
    ADD R8, R8, R9            @ storageIncrementer = storageIncrementer + countsSpace
    LDR R11, [R8]             @ content = storageIncrementer
    ADD R11, R11, #1          @ content++
    STR R11, [R8]             @ content = storageIncrementer
    B whileMode

 AddNewElements:
    MUL R8, R7, R8            @ storageIncrementer = count of unique elements * storageIncrementer
    ADD R8, R8, R9            @ storageIncrementer = storageIncrementer + countsSpace
    STR R5, [R8]              @ tempAdr = storageIncrementer
    ADD R8, R8, #4            @ storageIncrementer += 4
    MOV R12, #1               @ countOfValue = 1
    STR R12, [R8]             @ countOfValue = storageIncrementer
    ADD R7, R7, #1            @ count of unique elements++
    B whileMode

endMode:
  

End_Main:
  BX    lr
