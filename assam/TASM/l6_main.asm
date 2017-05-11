.model small
.stack 256
.data
    in_text db 'Enter text: ', 13, 10, '$'
    bye db 'bye', 13, 10, '$'

    ; choose
    choose_menu1 db 1
    choose_menu2 db 1
    choose_menu3 db 1

    input db 254 dup(255)
    output db 254 dup(255)

    buf dw 0
.code
.486
    mov ax, @data
    mov ds, ax

    mov ax, @data
    mov ds, ax
    mov es, ax
    xor eax, eax ; eax=0
    xor ebx, ebx ; eax=0
    xor ecx, ecx ; ecx=0
    xor edx, edx ; edx=0

    EXTRN menu1:proc
    EXTRN menu2:proc
    EXTRN menu3:proc
    EXTRN menu4:proc
    EXTRN base:proc
    EXTRN additionally:proc
    EXTRN clear_console:proc
    EXTRN console_input:proc
    EXTRN console_output:proc
    EXTRN file_input:proc
    EXTRN file_output:proc
    EXTRN print_string:proc

p_menu1:
    call clear_console
    call menu1
    mov choose_menu1, dl
    cmp choose_menu1, '0'
    jz exit

p_menu2:
    call menu2
    mov choose_menu2, dl
    cmp choose_menu2, '0'
    jz exit

    cmp choose_menu2, '3'
    jz p_menu1

    call menu3
    mov choose_menu3, dl
    cmp choose_menu3, '0'
    jz exit

    cmp choose_menu3, '3'
    jz p_menu2


; input
    cmp choose_menu2, '1'
    jnz p_file_input

    mov dx, 1
    push dx
    push offset in_text
    push offset input
    call console_input
    jmp p_make_task
p_file_input:
    push offset input
    call file_input
    cmp dx, 1 ;check error
    jz p_menu4

; make task
p_make_task:
    push offset output
    push offset input
    xor dx, dx
    mov dl, choose_menu2
    push dx

    cmp choose_menu1, '1'
    jnz p_additionally
    call base
    jmp p_output
p_additionally:
    call additionally

; output
p_output:
    push offset output

    cmp choose_menu3, '1'
    jnz p_file_output
    call console_output
    jmp p_menu4
p_file_output:
    call file_output

p_menu4:
    call menu4
    cmp dl, '0'
    jnz p_menu1

exit:
    push offset bye
    call print_string
    mov ax, 4c00h
    int 21h
end