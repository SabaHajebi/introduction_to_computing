  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global  get9x9
  .global  set9x9
  .global  average9x9
  .global  blur9x9


@ get9x9 subroutine
@ Retrieve the element at row r, column c of a 9x9 2D array
@   of word-size values stored using row-major ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@
@ Return:
@   R0: element at row r, column c

get9x9:
  PUSH    {R4-R8, LR}                      @ add any registers R4...R12 that you use  
  MOV R4, R0
  MOV R5, R1
  MOV R6, R2
  MOV R7, #9                              @ row size
  MUL R8, R5, R7                          @ index = row * row_size
  ADD R8, R8, R6                          @ index = index + col
  LDR R0, [R0, R8, LSL #2]                @ elem = word[ array + (index * elem_size)
  POP     {R4-R8, PC} 


@ set9x9 subroutine
@ Set the value of the element at row r, column c of a 9x9
@   2D array of word-size values stored using row-major
@   ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: value - new word-size value for array[r][c]
@
@ Return:
@   none
set9x9:
  PUSH    {R4-R8, LR}                      @ add any registers R4...R12 that you use
  MOV R5, R1
  MOV R6, R2
  MOV R7, #9                             
  MUL R8, R5, R7                          @ index = row * row_size
  ADD R8, R8, R6                          @ index = index + col              
  STR R3, [R0, R8, LSL #2]
  POP     {R4-R8, PC} 


@ average9x9 subroutine
@ Calculate the average value of the elements up to a distance of
@   n rows and n columns from the element at row r, column c in
@   a 9x9 2D array of word-size values. The average should include
@   the element at row r, column c.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number    (x)
@   R2: c - column number (y)
@   R3: n - element radius
@
@ Return:
@   R0: average value of elements
average9x9:
  PUSH    {LR}                      @ add any registers R4...R12 that you use

  POP     {PC}                      @ add any registers R4...R12 that you use



@ blur9x9 subroutine
@ Create a new 9x9 2D array in memory where each element of the new
@ array is the average value the elements, up to a distance of n
@ rows and n columns, surrounding the corresponding element in an
@ original array, also stored in memory.
@
@ Parameters:
@   R0: addressA - start address of original array
@   R1: addressB - start address of new array
@   R2: n - radius
@
@ Return:
@   none
blur9x9:
  PUSH    {LR}                      @ add any registers R4...R12 that you use

  @
  @ your implementation goes here
  @

  POP     {PC}                      @ add any registers R4...R12 that you use

.end