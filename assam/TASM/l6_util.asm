.model small
.stack 256
.data
    
.code
.486
    mov ax, @data
    mov ds, ax

public clear_console
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

public concat_count
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

public print_string
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
end