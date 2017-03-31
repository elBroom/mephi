;Построить вещественное число, целая часть которого есть длина первого слова строки; 
;каждая цифра в дробной части является длиной очередного слова строки.
;len(first word),len(second word)len(third word)...len(last word)
.model small
.data
.stack 256
.code
.486
    mov ax, @data
    mov ds, ax
    mov es, ax
    xor eax, eax ; eax=0
    xor ebx, ebx ; eax=0
    xor ecx, ecx ; ecx=0
    xor edx, edx ; edx=0

    mov ax, 4c00h
    int 21h

len proc nea2
	pusha
	pushf
	mov bp, sb
	mov ax, [bp+18]

	popf
	popa
	ret 2
len endp

end