;Построить вещественное число, целая часть которого есть длина первого слова строки;
;каждая цифра в дробной части является длиной очередного слова строки.
;len(first word),len(second word)len(third word)...len(last word)
.model small
.stack 256
.data
    str1 db 'ee wer qrr ', 0                   ;первая строка
        db 'er r r c',0                         ;вторая строка
        db '  ',0
        db ' Mama mu  ram rami  ',0
        db 'mi mi mii bu bu', 0
        db '  erew  r', 0
        db 'ee  wer rr', 0
        db 0
        db 'a aa aaa 1234 12345 123456 1234567 12345678 123456789 1234567890 yyyyyyyyyyyyyyy',0
        db 'ramayu',0,30 ;последняя стркоа, заканчивается символом 30 - конец файла
    str2 db 1000 dup(0)
    cnt db 0
.code
.486
    mov ax, @data
    mov ds, ax
    mov es, ax
    xor eax, eax ; eax=0
    xor ebx, ebx ; eax=0
    xor ecx, ecx ; ecx=0
    xor edx, edx ; edx=0

    lea si, str1 ; source
    lea di, str2 ; distination
    dec si
findWord:
    inc si
    mov al, 30 ; check EOF
    cmp al, [si]
    jz exit
    mov al, ' ' ; check space;Построить вещественное число, целая часть которого есть длина первого слова строки;
;каждая цифра в дробной части является длиной очередного слова строки.
;len(first word),len(second word)len(third word)...len(last word)
.model small
.stack 256
.data
    str1 db 'ee wer qrr ', 0                   ;первая строка
        db 'er r r c',0                         ;вторая строка
        db '  ',0
        db ' Mama mu  ram rami  ',0
        db 'mi mi mii bu bu', 0
        db '  erew  r', 0
        db 'ee  wer rr', 0
        db 0
        db 'a aa aaa 1234 12345 123456 1234567 12345678 123456789 1234567890 yyyyyyyyyyyyyyy',0
        db 'ramayu',0,30 ;последняя стркоа, заканчивается символом 30 - конец файла
    str2 db 1000 dup(0)
    cnt db 0
.code
.486
    mov ax, @data
    mov ds, ax
    mov es, ax
    xor eax, eax ; eax=0
    xor ebx, ebx ; eax=0
    xor ecx, ecx ; ecx=0
    xor edx, edx ; edx=0

    lea si, str1 ; source
    lea di, str2 ; distination
    dec si
findWord:
    inc si
    mov al, 30 ; check EOF
    cmp al, [si]
    jz exit
    mov al, ' ' ; check space
    cmp al, [si]
    jz chkLen
    mov al, 0 ; check end line
    cmp al, [si]
    jz chkLen
    inc dx ;count symbols
    jmp findWord
chkLen:
    cmp dx, 0
    jz newLine

    cmp cnt, 1
    jnz addLen
    mov al, '.'
    stosb ; add point

addLen:
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

    inc cnt
    xor dx, dx
    xor ax, ax

newLine:
    mov al, ' ' ; check space
    cmp al, [si]
    jz findWord

    mov al, 0
    stosb ; add end line
    mov cnt, 0
    jmp findWord

exit:
    stosb ; add EOF
    mov ax, 4c00h
    int 21h
end
    cmp al, [si]
    jz chkLen
    mov al, 0 ; check end line
    cmp al, [si]
    jz chkLen
    inc dx ;count symbols
    jmp findWord
chkLen:
    cmp dx, 0
    jz newLine

    cmp cnt, 1
    jnz addLen
    mov al, '.'
    stosb ; add point

addLen:
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

    inc cnt
    xor dx, dx
    xor ax, ax

newLine:
    mov al, ' ' ; check space
    cmp al, [si]
    jz findWord

    mov al, 0
    stosb ; add end line
    mov cnt, 0
    jmp findWord

exit:
    stosb ; add EOF
    mov ax, 4c00h
    int 21h
end