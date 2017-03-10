;dd palindromes
.model small
.data
    a dd 1D7h ; 111010111b
    result db 0 ; 5 5h
    padding db 0 ; 23d 17h 
    len db 0 ;9h len/2=4h
    lhead db ?
    ltail db ?

.const
    WORD_SIZE equ 32d

.code
.486
    mov ax, @data
    mov ds, ax
    xor eax, eax ; eax=0
    mov eax, a ; load a to ax
    cmp eax, 0 ; check number 0
    jz addOne
    cmp eax, 1 ; check number 1
    jz addOne
skip: ; calculate padding
    inc padding
    shl eax, 1 ; last symbol is zero
    jnc skip

    dec padding
    add eax, 1
    ; cycle shift right
    ror eax, 1 ; return one to number
    mov ebx, eax ; save tail

; calculate length number
    xor ecx, ecx ; ecx=0
    mov cl, WORD_SIZE
    sub cl, padding ; len
    mov len, cl
    shr cl, 1; len/2
    mov edx, a ; save head

calc: ; start loop
    mov lhead, 0
    shr edx, 1 ; get first symbol
    jnc getTail
    mov lhead, 1 ; save first symbol
getTail:
    mov ltail, 0
    shl ebx, 1 ; get last symbol
    jnc compare
    mov ltail, 1 ; save last symbol
compare: ; compare last and first symbols
    xor eax, eax ; eax=0
    mov al, lhead
    xor al, ltail
    jnz exit
    inc result
    loop calc

continue: ; check even len
    mov al, len
    shr al, 1
    jnc exit

addOne: ; add one for odd len
    inc result
exit:
    mov ah, 4ch
    int 21h
end