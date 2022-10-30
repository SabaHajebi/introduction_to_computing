  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Follow the instructions in the handout for Assignment 4 

   @ How many peime numbers less than N (R1=N)
   @ R7 is my counter for numbers to be tested (2 <= R7 < N); @ R7 is i
   @ R0 counts how many primes less than N

   MOV R0, #0 
   MOV R7, #2

  MainWhile:
    CMP R7, R1
    BGE EndMainWhile

    Test_i_prime:
      MOV R2, #2  @ R2 is divisor
      MOV R3, #1  @ R3 is remainder 
    
      While:

        CMP R2, R7
        BGE EndWhile

        CMP R3, #0
        BEQ EndWhile

        UDIV R4, R7, R2
        MUL R3, R4, R2
        SUB R3, R7, R3
        ADD R2, R2, #1
        B While

      EndWhile: 
        CMP R3, #0
        BEQ NotPrime
        ADD R0, #1
        B End_Test_i_prime

      NotPrime:
      B End_Test_i_prime

    End_Test_i_prime:
      ADD R7, #1
      B MainWhile

  EndMainWhile:





  @ End of program ... check your result

End_Main:
  BX    lr
