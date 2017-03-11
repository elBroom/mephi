;dd palindromes
.model small
.data
    w dd 069F531Fh
    result db 0
.code
.486
    mov ax, @data
    mov ds, ax
    xor eax, eax ; eax=0
    xor ebx, ebx ; eax=0
    xor ecx, ecx ; ecx=0
    xor edx, edx ; edx=0
    mov eax, w
    mov cl, 4
calc: ; start loop
    mov bl, al
    mov dl, al
    shr dl, 4 ; head
    and bl, 0Fh ; tail
    xor bl, dl
    jnz endLoop
    inc result
endLoop:
    shr eax, 8
    loop calc

    mov ah, 4ch
    int 21h
end