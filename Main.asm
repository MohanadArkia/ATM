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

section .bss
    balance              resd 1
    input_buffer         resb 10
    press_enter_buffer   resb 2

section .text
    global _start

_start:
    PUSH 27
    PUSH divider
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 15
    PUSH greeting
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 27
    PUSH divider
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 12
    PUSH option1
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 11
    PUSH option2
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 19
    PUSH option3
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 8
    PUSH option4
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 19
    PUSH select_an_option
    CALL PRINT_STRING
    ADD ESP, 8

    CALL INPUT
    CALL INPUT_CONTROLLER
    JMP _start

PRINT_STRING:
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, [ESP+4]
    MOV EDX, [ESP+8]
    INT 0x80
    RET

ENTER_TO_CONTINUE:
    PUSH 26
    PUSH press_enter_text
    CALL PRINT_STRING
    ADD ESP, 8
    
    MOV EAX, 3
    MOV EBX, 0
    MOV ECX, press_enter_buffer
    MOV EDX, 1
    INT 0x80
    RET

DISPLAY_BALANCE_OPTION:
    PUSH 27
    PUSH divider
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 18
    PUSH balance_text
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    PUSH 27
    PUSH divider
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE

    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

DEPOSIT_OPTION:
    PUSH 23
    PUSH deposit_option
    CALL PRINT_STRING
    ADD ESP, 8

    CALL INPUT
    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

WITHDRAW_OPTION:
    PUSH 26
    PUSH withdraw_option
    CALL PRINT_STRING
    ADD ESP, 8

    CALL INPUT
    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

CLEAR_SCREEN:
    PUSH 8
    PUSH clear_screen
    CALL PRINT_STRING
    ADD ESP, 8
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
    PUSH 36
    PUSH invalid_input
    CALL PRINT_STRING
    ADD ESP, 8
    
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
    PUSH 1
    PUSH new_line
    CALL PRINT_STRING
    ADD ESP, 8
    RET

EXIT:
    PUSH 5
    PUSH bye_message
    CALL PRINT_STRING
    ADD ESP, 8
    CALL NEW_LINE
    MOV EAX, 1
    XOR EBX, EBX
    INT 0x80
