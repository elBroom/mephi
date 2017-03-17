;dd palindromes
.model small
.data
    w dd 010FFFFFEh
    result db 0 ;2
    buf db 0
    head db ?
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
    mov head, dl; save head
    mov buf, cl; save counter

    xor cx, cx 
    xor dx, dx
    mov cl, 4
    revert: ; revert tail
        shl dl, 1
        shr bl, 1
        jnc endRev ;carry flag
        add dl, 1
    endRev:
        loop revert

    mov cl, buf
    mov bl, head
    xor bl, dl
    jnz endLoop
    inc result
endLoop:
    shr eax, 8
    loop calc

    mov ah, 4ch
    int 21h
end