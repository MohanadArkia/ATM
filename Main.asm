section .data
    divider           db "=========================="            , 0
    greeting          db "Welcome to ATM"                        , 0
    new_line          db 10                                      , 0
    option1           db "1. Withdraw"                           , 0
    option2           db "2. Deposit"                            , 0
    option3           db "3. Display Balance"                    , 0
    option4           db "4. Exit"                               , 0
    select_an_option  db "Select an option: "                    , 0
    withdraw_option   db "Enter withdrawal amount: "             , 0
    deposit_option    db "Enter deposit amount: "                , 0
    invalid_input     db "Invalid input, select between 1 - 4"   , 0
    bye_message       db "Bye!"                                  , 0
    clear_screen      db 0x1B, '[2J', 0x1B, '[H'                 , 0
    press_enter_text  db "Press enter to continue.."             , 0
    balance_text      db "Your balance is: "                     , 0
    insufficient_text db "Insufficient funds"                    , 0

section .bss
    balance                     resd 1
    balance_str_buffer          resb 10
    input_buffer                resb 10
    press_enter_buffer          resb 1

section .text
    %MACRO PRINT 2
        PUSH %1
        PUSH %2
        CALL PRINT_STRING
        ADD ESP, 8
    %ENDMACRO
    global _start
_start:

    PRINT 27, divider
    CALL NEW_LINE

    PRINT 15, greeting
    CALL NEW_LINE

    PRINT 27, divider
    CALL NEW_LINE

    PRINT 12, option1
    CALL NEW_LINE

    PRINT 11, option2
    CALL NEW_LINE

    PRINT 19, option3
    CALL NEW_LINE

    PRINT 8, option4
    CALL NEW_LINE

    PRINT 19, select_an_option

    CALL INPUT
    CALL INPUT_CONTROLLER
    JMP _start

CONVERT_STRING_TO_INT:
    XOR EAX, EAX
    XOR ECX, ECX

CONVERT_STRING_TO_INT_LOOP:
    MOV BL, [input_buffer + ECX]
    CMP BL, 10
    JE CONVERT_STRING_TO_INT_DONE

    SUB BL, '0'
    IMUL EAX, EAX, 10
    ADD EAX, EBX

    INC ECX
    JMP CONVERT_STRING_TO_INT_LOOP

CONVERT_STRING_TO_INT_DONE:
    RET

CONVERT_BALANCE_TO_STRING:
    MOV EAX, [balance]
    MOV EBX, 10
    MOV ECX, balance_str_buffer + 9
    ADD ECX, 1
    MOV BYTE [ECX], 0

REVERSE_BALANCE_DIGITS:
    DEC ECX
    XOR EDX, EDX
    DIV EBX
    ADD DL, '0'
    MOV [ECX], DL
    TEST EAX, EAX
    JNZ REVERSE_BALANCE_DIGITS
    RET

PRINT_STRING:
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, [ESP+4]
    MOV EDX, [ESP+8]
    INT 0x80
    RET

ENTER_TO_CONTINUE:
    PRINT 26, press_enter_text
    MOV EAX, 3
    MOV EBX, 0
    MOV ECX, press_enter_buffer
    MOV EDX, 1
    INT 0x80
    RET

DISPLAY_BALANCE_OPTION:
    PRINT 27, divider
    CALL NEW_LINE

    PRINT 18, balance_text

    CALL CONVERT_BALANCE_TO_STRING
    PRINT 10, balance_str_buffer
    CALL NEW_LINE

    PRINT 27, divider
    CALL NEW_LINE

    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

DEPOSIT_OPTION:
    PRINT 23, deposit_option
    CALL INPUT
    CALL CONVERT_STRING_TO_INT

    ADD [balance], EAX

    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

WITHDRAW_OPTION:
    PRINT 26, withdraw_option
    CALL INPUT
    CALL CONVERT_STRING_TO_INT

    MOV EBX, [balance]
    CMP EAX, EBX
    JA INSUFFICIENT_FUNDS
    SUB [balance], EAX

    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

INSUFFICIENT_FUNDS:
    PRINT 27, divider
    CALL NEW_LINE
    PRINT 20, insufficient_text
    CALL NEW_LINE
    PRINT 27, divider
    CALL NEW_LINE
    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

CLEAR_SCREEN:
    PRINT 8, clear_screen
    RET

INPUT_CONTROLLER:
    MOV AL, [input_buffer]
    CMP AL, '1'
    JE  WITHDRAW_OPTION
    CMP AL, '2'
    JE  DEPOSIT_OPTION
    CMP AL, '3'
    JE DISPLAY_BALANCE_OPTION
    CMP AL, '4'
    JE EXIT

    ; Handle invalid input
    PRINT 36, invalid_input
    
    CALL NEW_LINE
    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET
    
INPUT:
    MOV EAX, 3
    MOV EBX, 0
    MOV ECX, input_buffer
    MOV EDX, 10
    INT 0x80
    RET

NEW_LINE:
    PRINT 1, new_line
    RET

EXIT:
    PRINT 5, bye_message
    CALL NEW_LINE
    MOV EAX, 1
    XOR EBX, EBX
    INT 0x80
