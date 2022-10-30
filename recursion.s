  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   quicksort
  .global   partition
  .global   swap

@ quicksort subroutine
@ Sort an array of words using Hoare's quicksort algorithm
@ https://en.wikipedia.org/wiki/Quicksort 
@
@ Parameters:
@   R0: Array start address
@   R1: lo index of portion of array to sort
@   R2: hi index of portion of array to sort
@
@ Return:
@   none
quicksort:
  PUSH    {R4-R11,LR}                      @ add any registers R4...R12 that you use

  @ *** PSEUDOCODE ***
  @ if (lo < hi) { // !!! You must use signed comparison (e.g. BGE) here !!!
  @   p = partition(array, lo, hi);
  @   quicksort(array, lo, p - 1);
  @   quicksort(array, p + 1, hi);
  @ }
  MOV R7, R0
  MOV R8, R1 @ lo
  MOV R9, R2 @ hi


  .Lif:
    CMP R8, R9
    BGE .Lendif
    MOV R0, R7
    MOV R1, R8 @ lo
    MOV R2, R9 @ hi
    BL partition @ R12 stores return value
    MOV R10, R0

    MOV R0, R7
    MOV R1, R8 @ lo
    MOV R2, R10 @ p
    SUB R2, R2, #1
    BL quicksort

    MOV R0, R7
    MOV R1, R10 @ p
    ADD R1, R1, #1
    MOV R2, R9 @ hi
    BL quicksort 
    B .Lif

 .Lendif:

  POP     {R4-R11, PC}                      @ add any registers R4...R12 that you use


@ partition subroutine
@ Partition an array of words into two parts such that all elements before some
@   element in the array that is chosen as a 'pivot' are less than the pivot
@   and all elements after the pivot are greater than the pivot.
@
@ Based on Lomuto's partition scheme (https://en.wikipedia.org/wiki/Quicksort)
@
@ Parameters:
@   R0: array start address
@   R1: lo index of partition to sort
@   R2: hi index of partition to sort
@
@ Return:
@   R0: pivot - the index of the chosen pivot value
partition:
  PUSH    {R4-R12, LR}               @ add any registers R4...R12 that you use

  @ *** PSEUDOCODE ***
  @ pivot = array[hi];
  @ i = lo;
  @ for (j = lo; j <= hi; j++) {
  @   if (array[j] < pivot) {
  @     swap (array, i, j);
  @     i = i + 1;
  @   }
  @ }
  @ swap(array, i, hi);
  @ return i;

  MOV R8, R0
  MOV R12, R2
  
  LDR R4, [R0, R2, LSL #2]          @ pivot = array[hi];  
  MOV R9, R1                        @ i = lo; R9 is i
  MOV R6, R1                        @ int j = lo
  SUB R6, R6, #1

 .Lwhile:
   ADD R6, R6, #1                   @ j++
   CMP R6, R12                       @ j <= hi    
   BGT .LendWhile
   LDR R7, [R0, R6, LSL #2]         @ array[j]
   CMP R7, R4                       @ if (array[j] < pivot)
   BGE .Lwhile 

   MOV R0, R8
   MOV R1, R9
   MOV R2, R6 
   BL swap                          @ swap (array, i, j); swap(array, R10, R11)
   ADD R9, R9, #1                   @  i = i + 1;
   B .Lwhile

 .LendWhile:
 MOV R0, R8
 MOV R1, R9                   
 MOV R2, R12
 BL swap
 MOV R0, R9
 POP     {R4-R12, PC}                @ add any registers R4...R12 that you use



@ swap subroutine
@ Swap the elements at two specified indices in an array of words.
@
@ Parameters:
@   R0: array - start address of an array of words
@   R10: a - index of first element to be swapped
@   R11: b - index of second element to be swapped
@
@ Return:
@   none
swap:
  PUSH    {R4, R5, LR}
  LDR R4, [R0, R1, LSL #2]
  LDR R5, [R0, R2, LSL #2]
  STR R4, [R0, R2, LSL #2]
  STR R5, [R0, R1, LSL #2]
  POP     {R4, R5, PC}


.end