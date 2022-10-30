  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Follow the instructions in the handout for Assignment 7

  @
  @ TIP: To view memory when debugging your program you can ...
  @
  @   Add the watch expression to see individual characters: (char[64])newString
  @
  @   OR
  @
  @   Add the watch expression to see the string: (char*)&newString
  @
  @   OR
  @
  @   Open a 'Memory View' specifying the address &newString and length at
  @   least 128. You can open a Memory View with ctrl-shift-p type
  @   'View Memory' (cmd-shift-p on a Mac).
  @


  MOV  R9, #0                 @ Boolean flag = false;
  LDR  R3, =0x20              @ space

  whileUntilNull:
    LDRB R4, [R1]             @ ch = byte[address];
    CMP R4, #0                @ while (ch != 0)
    BEQ endWhileUntilNull     @ {

    CMP R4, R3                @   if (ch == space)
    BEQ dealWithSpace         @   {

    CMP R4, #'A'              @      if (ch >= 'A' && ch <= 'Z')
    BLO NonChar               @        {
    CMP R4, #'Z'              @
    BHI CheckLowerCase        @ 
    CMP R9, #1                @           if (flag == true)
    BEQ UpperCaseSpaceBefore  @              {
    ADD R4, R4, #0x20         @     ch = ch + 0x20;
    STRB R4, [R0]             @     byte[address] = ch;
    ADD R0, R0, #1            @     result[address] =  result[address] + 1
    ADD R1, R1, #1            @     address = address + 1
    B whileUntilNull          @    }

  CheckLowerCase:
    CMP R4, #'a'              @ if (ch >= 'a' && ch <= 'z')
    BLO NonChar               @ {
    CMP R4, #'z'              @
    BHI NonChar               @
    CMP R9, #1                @   if (flag == true)
    BEQ LowerCaseSpaceBefore  @     {
    STRB R4, [R0]             @ byte[address] = ch;
    ADD R0, R0, #1            @ result[address] =  result[address] + 1
    ADD R1, R1, #1            @ address = address + 1
    B whileUntilNull          @ }

  UpperCaseSpaceBefore:
    STRB R4, [R0]             @ byte[address] = ch;
    ADD R0, R0, #1            @ result[address] =  result[address] + 1
    ADD R1, R1, #1            @ address = address + 1
    MOV R9, #0                @ flag == false
    B whileUntilNull          @ }

  LowerCaseSpaceBefore:       
    SUB  R4, R4, #0x20        @ ch = ch - 0x20
    STRB R4, [R0]             @ byte[address] = ch;
    ADD  R0, R0, #1           @ result[address] =  result[address] + 1
    ADD  R1, R1, #1           @ address = address + 1
    MOV R9, #0                @ flag == false
    B whileUntilNull          @ }

  dealWithSpace:
    MOV R9, #1                @ flag == true 
    ADD R1, R1, #1            @ address = address + 1
    B whileUntilNull          @ }
    
  NonChar:
    ADD R1, R1, #1            @ address = address + 1
    B whileUntilNull          @ }

endWhileUntilNull:
  

  @ End of program ... check your result


End_Main:
  BX    lr
