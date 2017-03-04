;dw palindromes
.model small
.data
    count db 9d
    feven db 0

.code
.486
    mov ax, @data
    mov ds, ax
    xor eax, eax ; eax=0
    mov al, count
    shr al, 1
    jnc exit
    mov feven, 1
    cmp feven, 0
    jz exit
    mov ax, 0FFFFh
exit:
    mov ah, 4ch
    int 21h
end