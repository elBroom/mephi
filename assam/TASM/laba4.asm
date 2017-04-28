;Построить вещественное число, целая часть которого есть длина первого слова строки;
;каждая цифра в дробной части является длиной очередного слова строки.
;len(first word),len(second word)len(third word)...len(last word)
.model small
.stack 256
.data
    ; str1 db 'ee,,wer ;rr ', 0                   ;первая строка
    ;     db 'er r r c',0                         ;вторая строка
    ;     db '  ',0
    ;     db ' Mama mu  ram rami  ',0
    ;     db 'mi mi mii bu bu', 0
    ;     db '  erew  r', 0
    ;     db 'ee  wer rr', 0
    ;     db 0
    ;     db 'a aa aaa 1234 12345 123456 1234567 12345678 123456789 1234567890 yyyyyyyyyyyyyyy',0
    str1 db '12 123',0
        db 'ramayu',0,30 ;последняя стркоа, заканчивается символом 30 - конец файла
    init dd 0.0
    res dd ?
    poWord dw 1
    ten dw 10
    buf dw ?
.code
.486
    mov ax, @data
    mov ds, ax
    mov es, ax
    xor eax, eax ; eax=0
    xor ebx, ebx ; eax=0
    xor ecx, ecx ; ecx=0
    xor edx, edx ; edx=0

    mov ecx, 10
    fld init
    lea di, str1
    dec di
findWord:
    inc di
    mov al, ' ' ; check space
    cmp al, [di]
    jz chkLen
    mov al, 0 ; check end line
    cmp al, [di]
    jz chkLen
    mov al, 30 ; check end string
    cmp al, [di]
    jz chkLen
    inc dx ;count symbols
    jmp findWord
chkLen:
    cmp dx, 0
    jz incLine

    mov buf, dx
    fild buf
    fild poWord
    fdiv
    fadd
    ; fist res
    xor dx, dx

incLine:
    mov al, 30 ; check end string
    cmp al, [di]
    jz exit

    xor ax, ax
    mov ax, poWord ;incremenet power
    mul ten
    mov poWord, ax

    xor ax, ax
    mov al, ' ' ; check space
    cmp al, [di]
    jz findWord

    mov poWord, 1
    ; call printFloat
    fstp res
    fld init
    push res

    mov al, 0 ; check end line
    cmp al, [di]
    jz findWord

exit:
    ; call printFloat
    mov ax, 4c00h
    int 21h


printInt:
pushad
  mov  bx,sp
  mov  byte ptr ss:[bx-1],'$'  ;символ конца строки
  @1:cdq
     div  ecx              ;делим число на основание edx - остаток, eax - частное
     mov  bp,dx            ;преобразование в ASCII
     mov  dl,cs:[symbols+bp]
     dec  bx
     mov  ss:[bx-1],dl
     test eax,eax
  jne @1
  mov  ax,ss               ;выводим строку на экран
  mov  ds,ax
  dec  bx
  mov  dx,bx
  xchg sp,bx
  mov  ah,9
  int  21h
  xchg sp,bx
popad
ret
symbols db '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

printFloat:
pushad
  push ecx
  mov  bp,sp
  fst  dword ptr ss:[bp-4]
  xor  eax,eax
  mov  edx,ss:[bp-4]

  shl  edx,1
  jnc @2         ;Если установлен старший бит
  pushad         ;значит число отрицательное - выводим минус
  mov  dl,'-'
  mov  ah,2
  int  21h
  popad
  @2:
  mov  ecx,edx

  shr  ecx,24
  sub  cx,126        ;Порядок (экспонента)

  shl  edx,7
  or   edx,80000000h     ;Значащие биты (мантисса)

  shld eax,edx,cl    ;eax - целая часть
  shl  edx,cl        ;edx - дробная часть
  pop  ecx
  call printInt      ;выводим на экран целую часть

  test edx,edx       ;если дробная часть не равна нулю - выводим её на экран
  je   exitPrintFloat
  xchg eax,edx
  cdq
  sub  bp,28
  mov  byte ptr ss:[bp],'.'
  @3:mul  ecx
     add  dl,'0'
     inc  bp
     mov  ss:[bp],dl
     test eax,eax
  jne @3
  mov  byte ptr ss:[bp],10
  mov  byte ptr ss:[bp+1],'$'
  sub  sp,32
  push ss
  pop  ds
  mov  dx,sp
  mov  ah,9
  int  21h
  add  sp,32
  exitPrintFloat:
popad
ret

end