.model small
.stack 256
.data
    men1 db 'Enter task:', 13, 10, '$'
    men2 db 'Enter input mode:', 13, 10, '$'
    men3 db 'Enter output mode:', 13, 10, '$'
    men4 db 'Continue:', 13, 10, '$'
    itm1 db 'exit', 13, 10, '$'
    itm2 db 'previos menu', 13, 10, '$'
    itm3 db 'console', 13, 10, '$'
    itm4 db 'file', 13, 10, '$'
    itm5 db 'base', 13, 10, '$'
    itm6 db 'additionally', 13, 10, '$'
    itm7 db 'continue', 13, 10, '$'
    num0 db '0 - $'
    num1 db '1 - $'
    num2 db '2 - $'
    num3 db '3 - $'
    incorrect db 'incorrect answer', 13, 10, '$'
    CRLF    db  13, 10,'$'

    ; choose
    choose_menu db 1
.code
.486
    mov ax, @data
    mov ds, ax

    EXTRN print_string:proc

public menu1
menu1 proc near
    pusha
    pushf

    push offset men1
    call print_string

    push offset num1
    call print_string
    push offset itm5
    call print_string

    push offset num2
    call print_string
    push offset itm6
    call print_string

    push offset num0
    call print_string
    push offset itm1
    call print_string

    menu1_input:
        mov ah, 01h ; resul AL
        INT 21h
        push offset CRLF
        call print_string

        cmp al, '0'
        jz menu1_save
        cmp al, '1'
        jz menu1_save
        cmp al, '2'
        jz menu1_save

        lea dx, incorrect
        mov ah, 9
        int 21h

        jmp menu1_input

    menu1_save:
        mov choose_menu, al

    popf
    popa

    xor dx, dx
    mov dl, choose_menu
    ret
menu1  endp

public menu2
menu2 proc near
    pusha
    pushf

    push offset men2
    call print_string

    push offset num1
    call print_string
    push offset itm3
    call print_string

    push offset num2
    call print_string
    push offset itm4
    call print_string

    push offset num3
    call print_string
    push offset itm2
    call print_string

    push offset num0
    call print_string
    push offset itm1
    call print_string

    menu2_input:
        mov ah, 01h ; resul AL
        INT 21h
        push offset CRLF
        call print_string

        cmp al, '0'
        jz menu2_save
        cmp al, '1'
        jz menu2_save
        cmp al, '2'
        jz menu2_save
        cmp al, '3'
        jz menu2_save

        lea dx, incorrect
        mov ah, 9
        int 21h

        jmp menu2_input

    menu2_save:
        mov choose_menu, al

    popf
    popa

    xor dx, dx
    mov dl, choose_menu
    ret
menu2  endp

public menu3
menu3 proc near
    pusha
    pushf

    push offset men3
    call print_string

    push offset num1
    call print_string
    push offset itm3
    call print_string

    push offset num2
    call print_string
    push offset itm4
    call print_string

    push offset num3
    call print_string
    push offset itm2
    call print_string

    push offset num0
    call print_string
    push offset itm1
    call print_string

    menu3_input:
        mov ah, 01h ; resul AL
        INT 21h
        push offset CRLF
        call print_string

        cmp al, '0'
        jz menu3_save
        cmp al, '1'
        jz menu3_save
        cmp al, '2'
        jz menu3_save
        cmp al, '3'
        jz menu3_save

        lea dx, incorrect
        mov ah, 9
        int 21h

        jmp menu3_input

    menu3_save:
        mov choose_menu, al

    popf
    popa

    xor dx, dx
    mov dl, choose_menu
    ret
menu3  endp

public menu4
menu4 proc near
    pusha
    pushf

    push offset men4
    call print_string

    push offset num1
    call print_string
    push offset itm7
    call print_string

    push offset num0
    call print_string
    push offset itm1
    call print_string

    menu4_input:
        mov ah, 01h ; resul AL
        INT 21h
        push offset CRLF
        call print_string

        cmp al, '0'
        jz menu4_save
        cmp al, '1'
        jz menu4_save

        lea dx, incorrect
        mov ah, 9
        int 21h

        jmp menu4_input

    menu4_save:
        mov choose_menu, al

    popf
    popa

    xor dx, dx
    mov dl, choose_menu
    ret
menu4  endp

end