  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @ R1 (old) = 6, 2 ; R2 (new) = 3, 9
  @ R1 (old) = 3, 9 ; R2 (new) = 6, 2
  
  @ write your program here
  @ 3, 6, 1, *9, 0, 7, *2, 8, 6, 4
  @ 3, 6, 1, 0, 7, 2, *9, 8, 6, 4
                        
  LDR R3, [R0, R1, LSL #2]            @ numberToBeMoved	= Memory.byte[arrayAddr + 4 * startOldIndex]
  LDR R4, [R0, R2, LSL #2]            @ otherNum = Memory.byte[arrayAddr + 4 * startNewIndex]
  STR R3, [R0, R2, LSL #2]            @ numberToBeMoved	= Memory.byte[arrayAddr + 4 * startNewIndex]

While:
  CMP R1, R2                          @ while(old index > new index){
  BLS endWhile                        
  SUB R7, R1, #1                      @ tempAdr = oldIndedx--
  LDR R5, [R0, R7, LSL #2]            @ currentNum = tempAdr
  STR	R5, [R0, R1, LSL #2]            @ currentNUm = oldIndex
  SUB R1, #1                          @ oldIndex--
  B While                          

endWhile:
  SUB R2, R2, #1                     @ newIndex--
  STR R4, [R0, R2, LSL #2]           @ otherNum = Memory.byte[arrayAddr + 4 * startNewIndex]
  B While

  @ End of program ... check your result

End_Main:
  BX    lr

