;Построить вещественное число, целая часть которого есть длина первого слова строки;
;каждая цифра в дробной части является длиной очередного слова строки.
;len(first word),len(second word)len(third word)...len(last word)
;http://www.avprog.narod.ru/progs/fdos01.html
.model small
.stack 256
.data
    ;helper
    in_text db 'Enter text: ', 13, 10, '$'
    
    file_in db 'Enter filename input:', 13, 10, '$'
    file_load db 'File loaded', 13, 10, '$'
    file_err_permission db 'Permission denied', 13, 10, '$'
    file_err_not_found db 'Error file not found', 13, 10, '$'
    file_err_not_found_path db 'Error path not found', 13, 10, '$'
    file_err_open db 'Error open file', 13, 10, '$'
    file_err_read db 'Error read file', 13, 10, '$'
    
    file_out db 'Enter filename output:', 13, 10, '$'
    file_create db 'File created and writed', 13, 10, '$'
    file_open db 'File opend and writed', 13, 10, '$'
    file_err_oc db 'Error open or create file', 13, 10, '$'
    file_err_write db 'Error write file', 13, 10, '$'

    res db 'Result: ', 13, 10, '$'
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
    bye db 'bye', 13, 10, '$'
    CRLF    db  13, 10,'$'

    input db 300 dup('$')
    output db 300 dup('$')
    filename db 36 dup('$')

    ; choose
    choose_menu1 db 1
    choose_menu2 db 1
    choose_menu3 db 1

    buf dw 0
.code
.486
    mov ax, @data
    mov ds, ax
    mov es, ax
    xor eax, eax ; eax=0
    xor ebx, ebx ; eax=0
    xor ecx, ecx ; ecx=0
    xor edx, edx ; edx=0

p_menu1:
    call clear_console
    call menu1

p_menu2:
    call menu2
    cmp choose_menu2, '3'
    jz p_menu1

    call menu3
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
    call file_input
    cmp buf, 1 ;check error
    jz p_menu4

; make task
p_make_task:
    cmp choose_menu1, '1'
    jnz p_additionally
    call base
    jmp p_output
p_additionally:
    call additionally

; output
p_output:
    cmp choose_menu3, '1'
    jnz p_file_output
    call console_output
    jmp p_menu4
p_file_output:
    call file_output

p_menu4:
    call menu4
    jmp p_menu1

exit:
    push offset bye
    call print_string
    mov ax, 4c00h
    int 21h

base proc near
    pusha
    pushf
        xor dx, dx
        mov buf, 0

        lea si, input ; source
        lea di, output ; distination
        dec si

        cmp choose_menu2, '1'
        jnz b_findWord
        add si, 2

    b_findWord:
        inc si
        mov al, '$' ; check EOF
        cmp al, [si]
        jz b_exit
        mov al, ' ' ; check space
        cmp al, [si]
        jz b_chkLen
        mov al, 13 ; check end line
        cmp al, [si]
        jz b_chkLen
        inc dx ;count symbols
        jmp b_findWord

    b_chkLen:
        cmp dx, 0
        jz b_newLine

        cmp buf, 1
        jnz b_addLen
        mov al, '.'
        stosb ; add point

    b_addLen:
        call concat_count

        inc buf
        xor dx, dx
        xor ax, ax

    b_newLine:
        mov al, ' ' ; check space
        cmp al, [si]
        jz b_findWord

        mov al, 10
        cmp al, [di-1]
        jnz b_endLine

    b_setZero:
        mov al, '0'
        stosb ; add end line

    b_endLine:
        mov al, '$'
        cmp al, [di-1]
        jz b_setZero

        mov al, 13
        stosb ; add end line
        mov al, 10
        stosb ; add end line
        mov buf, 0
        inc si
        jmp b_findWord

    b_exit:
        stosb ; add EOF

    popf
    popa
    ret
base  endp

additionally proc near
    pusha
    pushf
        xor dx, dx
        mov buf, 0

        lea si, input ; source
        lea di, output ; distination
        dec si
        
        cmp choose_menu2, '1'
        jnz a_findWord
        add si, 2

    a_findWord:
        inc si
        mov al, '$' ; check EOF
        cmp al, [si]
        jz a_exit
        mov al, ' ' ; check space
        cmp al, [si]
        jz a_chkLen
        mov al, 13 ; check end line
        cmp al, [si]
        jz a_chkLen
        inc dx ;count symbols
        jmp a_findWord

    a_chkLen:
        cmp dx, buf
        jng a_newWord
        mov buf, dx

    a_newWord:
        xor edx, edx
        mov al, ' ' ; check space
        cmp al, [si]
        jz a_findWord

        mov dx, buf
        call concat_count

        mov al, ' '
        stosb ; add end line
        mov buf, 0
        xor edx, edx
        inc si
        jmp a_findWord

    a_exit:
        mov al, 13
        stosb ; add end line
        mov al, 10
        stosb ; add end line
        mov al, '$'
        stosb ; add EOF

    popf
    popa
    ret
additionally  endp

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
        jz exit
        cmp al, '1'
        jz menu1_save
        cmp al, '2'
        jz menu1_save

        lea dx, incorrect
        mov ah, 9
        int 21h

        jmp menu1_input

    menu1_save:
        mov choose_menu1, al

    popf
    popa
    ret
menu1  endp

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
        jz exit
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
        mov choose_menu2, al

    popf
    popa
    ret
menu2  endp

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
        jz exit
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
        mov choose_menu3, al

    popf
    popa
    ret
menu3  endp

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
        jz exit
        cmp al, '1'
        jz menu4_exit

        lea dx, incorrect
        mov ah, 9
        int 21h

        jmp menu4_input

    menu4_exit:

    popf
    popa
    ret
menu4  endp

; util
clear_console proc near
    pusha
    mov ax,0600h  ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    mov bh,07h    ;0(black) FOR BACKGROUND AND 7 FOR FOREGROUND
    mov cx,0000h  ;0 row 0 col
    mov dx,184Fh  ;18 row 4F col (full screen) 
    int 10h
    popa
    ret
clear_console endp

concat_count proc near
    xor ax, ax
    mov ax, dx
    mov ebx,10  ;основание системы
    xor ecx,ecx ;в сх будет количество цифр в десятичном числе
    @@m1a:
        xor edx,edx
        div ebx     ;делим число на степени 10
        push edx        ;и сохраняем остаток от деления(коэффициенты при степенях) в стек
        inc ecx     ;увеличиваем количество десятичных цифр числа
        test eax,eax    ;после деления остался 0?
        jnz @@m1a   ;если нет, продолжаем
    @@m2a:
        pop eax     ;взять из стека цифру цисла
        add al,'0'  ;преобразовываем цифру в ASCII символ
        stosb       ;сохраняем в буфер
        loop @@m2a  ;все цифры
    ret
concat_count  endp

;get string from keyboard
;from stack head: str_addr, helper, end
console_input proc near
    pusha
    mov dx, [esp + 16 + 4]
    mov ah, 9
    int 21h

    mov dx, [esp + 16 + 2]
    mov ah,0ah
    int 21h


    xor bx, bx
    mov di, [esp + 16 + 2]
    mov bl, [di + 1]

    xor cx, cx
    mov cl, 0
    cmp [esp + 16 + 6], cl
    jz ci_zero
    mov byte ptr [di + bx + 2], 13
    mov byte ptr [di + bx + 4], 10
    mov byte ptr [di + bx + 6], '$'
    jmp ci_print

    ci_zero:
        mov byte ptr [di + bx + 2], 0

    ci_print:
        mov dx, [esp + 16 + 2]
        add dx, 2
        mov ah, 9
        int 21h

        lea dx, CRLF
        mov ah, 9
        int 21h

    popa
    ret 6
console_input endp

; print string to console
;from stack head: str_addr
print_string proc near
    pusha

    mov dx, [esp + 16 + 2]
    mov ah, 9
    int 21h

    popa
    ret 2
print_string endp

console_output proc near
    push offset res
    call print_string
    push offset output
    call print_string

    ret
console_output endp

file_input proc near
    pusha

    mov buf, 0
    mov dx, dx
    push dx
    push offset file_in
    push offset filename
    call console_input

    mov ah, 3Dh
    mov al, 0 ; open attribute: 0 - read-only, 1 - write-only, 2 -read&amp;write
    lea dx, filename ; ASCIIZ filename to open
    add dx, 2
    int 21h
    jc rf_open_error
    
    mov bx, ax ; handle we get when opening a file
    mov ah, 03Fh       
    mov cx, 0FFFFh ; number of bytes to read
    lea dx, input ; were to put read data
    int 21h
    jc rf_read_error
    
    mov ah, 03Eh ; close file, bx - handle
    int 21h
    
    xor ebx, ebx
    lea bx, input
    mov dl, '$'
    mov [ebx + eax], dl
    
    push offset file_load
    call print_string
    jmp rf_return
    
    rf_open_error:
        mov buf, 1
        cmp ax, 2
        jz rf_not_found
        cmp ax, 3
        jz rf_not_found_path
        cmp ax, 5
        jz rf_perm_den

        push offset file_err_open
        call print_string
        jmp rf_return
    rf_not_found:
        push offset file_err_not_found
        call print_string
        jmp rf_return
    rf_not_found_path:
        push offset file_err_not_found_path
        call print_string
        jmp rf_return
    rf_perm_den:
        push offset file_err_permission
        call print_string
        jmp rf_return
    rf_read_error:
        mov buf, 1
        push offset file_err_read
        call print_string
        jmp rf_return

    rf_return:
        popa
        ret
file_input endp

;from stack head: str_addr, filename
file_output proc near
    pusha
    mov dx, dx
    push dx
    push offset file_out
    push offset filename
    call console_input

    mov buf, 1
    
    wf_open:
        mov ah, 3Dh
        mov al, 1 ; open attribute: 0 - read-only, 1 - write-only, 2 -read&write
        lea dx, filename ; ASCIIZ filename to open
        add dx, 2
        int 21h
        jc wf_create
        jmp wf_write

    wf_write:
        mov ecx, 1
        xor ebx, ebx
        lea bx, output
        wf_length_loop:
            mov dl, [ebx]
            cmp dl, '$'
            je wf_write_go
            inc ecx
            inc ebx
            jmp wf_length_loop
        
        wf_write_go:
            dec ecx
            mov bx, ax ; handle we get when opening a file
            mov ah, 40h
            lea dx, output ; data to write
            int 21h
            jc wf_write_error
            
            mov ah, 3Eh ; close file, bx - handle
            int 21h
            jmp wf_status

    wf_create:
        mov buf, 0
        mov ah, 3Ch ; DOS create file
        mov cx, 0 ; attribute
        lea dx, filename ; filename in ASCIIZ
        add dx, 2
        int 21h
        jc wf_oc_error
        jmp wf_open
    
    wf_delete:
        mov bx, ax
        mov ah, 3Eh ; close file, bx - handle
        int 21h
        mov ah, 41h ; delete file
        lea dx, filename ; ASCIIZ filename to delete
        add dx, 2
        int 21h
        jmp wf_create
        
    wf_oc_error:
        cmp ax, 3
        jz wf_not_found
        cmp ax, 4
        jz wf_perm_den

        push offset file_err_oc
        call print_string
        jmp wf_exit
    wf_not_found:
        push offset file_err_not_found_path
        call print_string
        jmp wf_exit
    wf_perm_den:
        push offset file_err_permission
        call print_string
        jmp wf_exit
    wf_write_error:
        mov buf, 3
        jmp wf_status

    wf_status:
        cmp buf, 0
        jz wf_status_create
        cmp buf, 1
        jz wf_status_open
        cmp buf, 2
        jz wf_status_err_oc
        cmp buf, 3
        jz wf_status_err_write
        jmp wf_exit

    wf_status_create:
        push offset file_create
        call print_string
        jmp wf_exit
    wf_status_open:
        push offset file_open
        call print_string
        jmp wf_exit
    wf_status_err_oc:
        push offset file_err_oc
        call print_string
        jmp wf_exit
    wf_status_err_write:
        push offset file_err_write
        call print_string
        jmp wf_exit
    wf_exit:

    popa
    ret
file_output endp

end