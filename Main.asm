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
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, divider
    MOV EDX, 27
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, greeting
    MOV EDX, 15
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, divider
    MOV EDX, 27
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, option1
    MOV EDX, 12
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, option2
    MOV EDX, 11
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, option3
    MOV EDX, 19
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, option4
    MOV EDX, 8
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, select_an_option
    MOV EDX, 19
    INT 0x80

    CALL INPUT
    CALL INPUT_CONTROLLER

    JMP _start

ENTER_TO_CONTINUE:
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, press_enter_text
    MOV EDX, 26
    INT 0x80   
    
    MOV EAX, 3
    MOV EBX, 0
    MOV ECX, press_enter_buffer
    MOV EDX, 1
    INT 0x80
    RET

DISPLAY_BALANCE_OPTION:
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, divider
    MOV EDX, 27
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, balance_text
    MOV EDX, 18
    INT 0x80
    CALL NEW_LINE

    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, divider
    MOV EDX, 27
    INT 0x80
    CALL NEW_LINE

    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

DEPOSIT_OPTION:
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, deposit_option
    MOV EDX, 23
    INT 0x80
    CALL INPUT
    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

WITHDRAW_OPTION:
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, withdraw_option
    MOV EDX, 26
    INT 0x80
    CALL INPUT
    CALL ENTER_TO_CONTINUE
    CALL CLEAR_SCREEN
    RET

CLEAR_SCREEN:
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, clear_screen
    MOV EDX, 8
    INT 0x80
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
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, invalid_input
    MOV EDX, 36
    INT 0x80
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
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, new_line
    MOV EDX, 1
    INT 0x80
    RET

EXIT:
    MOV EAX, 4
    MOV EBX, 1
    MOV ECX, bye_message
    MOV EDX, 5
    INT 0x80
    CALL NEW_LINE
    MOV EAX, 1
    XOR EBX, EBX
    INT 0x80
