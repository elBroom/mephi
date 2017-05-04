;Построить вещественное число, целая часть которого есть длина первого слова строки;
;каждая цифра в дробной части является длиной очередного слова строки.
;len(first word),len(second word)len(third word)...len(last word)
.model small
.stack 256
.data
    ; input db 'ee wer qrr ', 13, 10                   ;первая строка
    ;     ; db 'er r r c',13, 10                         ;вторая строка
    ;     db '  ',13, 10
    ;     db ' Mama mu  ram rami  ',13, 10
    ;     db 'mi mi mii bu bu', 13, 10
    ;     db '  erew  r', 13, 10
    ;     db 'ee  wer rr', 13, 10
    ;     db 'a aa aaa 1234 12345 123456 1234567 12345678 123456789 1234567890 yyyyyyyyyyyyyyy',13, 10
    ;     db 'ramayu',13, 10,30 ;последняя стркоа, заканчивается символом 30 - конец файла
    input db 1000 dup(?)
    output db 1000 dup('$')
    cnt db 0

    res db 'Result: $', 13, 10
    men1 db 'Enter task: $',13, 10
    men2 db 'Enter input mode: $',13, 10
    men3 db 'Enter output mode: $',13, 10
    men4 db 'Continue: $',13, 10
    itm1 db 'exit $',13, 10
    itm2 db 'previos menu $',13, 10
    itm3 db 'console$ $',13, 10
    itm4 db 'file $',13, 10
    itm5 db 'base $',13, 10
    itm6 db 'additionally $',13, 10
    num0 db '0 - $'
    num1 db '1 - $'
    num2 db '2 - $'
    num3 db '3 - $'
    CRLF    db  13,10,'$'

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

    call menu1
    call menu2
    call menu3
    ; input STDIN
   

    call base
    ; output STDOUT
    lea dx,res
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h
    lea dx,output
    mov ah,9
    int 21h

    call menu4

    mov ax, 4c00h
    int 21h

base proc near
    pusha
    pushf

        lea si, input ; source
        lea di, output ; distination
        dec si

    b_findWord:
        inc si
        mov al, 30 ; check EOF
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
        mov ax, dx
        mov ebx,10  ;основание системы
        xor ecx,ecx ;в сх будет количество цифр в десятичном числе
    @@bm1a:
        xor edx,edx
        div ebx     ;делим число на степени 10
        push edx        ;и сохраняем остаток от деления(коэффициенты при степенях) в стек
        inc ecx     ;увеличиваем количество десятичных цифр числа
        test eax,eax    ;после деления остался 0?
        jnz @@bm1a   ;если нет, продолжаем
    @@bm2a:
        pop eax     ;взять из стека цифру цисла
        add al,'0'  ;преобразовываем цифру в ASCII символ
        stosb       ;сохраняем в буфер
        loop @@bm2a  ;все цифры

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
        mov al, '0'
        stosb ; add end line

    b_endLine:
        mov al, 13
        stosb ; add end line
        mov al, 10
        stosb ; add end line
        mov buf, 0
        inc si
        jmp b_findWord

    b_exit:
        ; stosb ; add EOF

    popf
    popa
    ret
base  endp

additionally proc near
    pusha
    pushf

    lea si, input ; source
    lea di, output ; distination
    dec si

    a_findWord:
        inc si
        mov al, 30 ; check EOF
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

            xor ax, ax
            mov ax, buf
            mov ebx,10  ;основание системы
            xor ecx,ecx ;в сх будет количество цифр в десятичном числе
        @@am1a:
            xor edx,edx
            div ebx     ;делим число на степени 10
            push edx        ;и сохраняем остаток от деления(коэффициенты при степенях) в стек
            inc ecx     ;увеличиваем количество десятичных цифр числа
            test eax,eax    ;после деления остался 0?
            jnz @@am1a   ;если нет, продолжаем
        @@am2a:
            pop eax     ;взять из стека цифру цисла
            add al,'0'  ;преобразовываем цифру в ASCII символ
            stosb       ;сохраняем в буфер
            loop @@am2a  ;все цифры

        mov al, ' '
        stosb ; add end line
        mov buf, 0
        xor edx, edx
        inc si
        jmp a_findWord

    a_exit:
        ; stosb ; add EOF

    popf
    popa
    ret
additionally  endp

menu1 proc near
    pusha
    pushf

    lea dx,men1
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num1
    mov ah,9
    int 21h
    lea dx,itm5
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num2
    mov ah,9
    int 21h
    lea dx,itm6
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num0
    mov ah,9
    int 21h
    lea dx,itm1
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    popf
    popa
    ret
menu1  endp

menu2 proc near
    pusha
    pushf

    lea dx,men2
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num1
    mov ah,9
    int 21h
    lea dx,itm3
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num2
    mov ah,9
    int 21h
    lea dx,itm4
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num3
    mov ah,9
    int 21h
    lea dx,itm1
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num0
    mov ah,9
    int 21h
    lea dx,itm1
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    popf
    popa
    ret
menu2  endp

menu3 proc near
    pusha
    pushf

    lea dx,men3
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num1
    mov ah,9
    int 21h
    lea dx,itm3
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num2
    mov ah,9
    int 21h
    lea dx,itm4
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num3
    mov ah,9
    int 21h
    lea dx,itm1
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num0
    mov ah,9
    int 21h
    lea dx,itm1
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    popf
    popa
    ret
menu3  endp

menu4 proc near
    pusha
    pushf

    lea dx,men4
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num1
    mov ah,9
    int 21h
    lea dx,itm6
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    lea dx,num0
    mov ah,9
    int 21h
    lea dx,itm1
    mov ah,9
    int 21h
    lea dx,CRLF
    mov ah,9
    int 21h

    popf
    popa
    ret
menu4  endp
end