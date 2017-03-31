;array[N][N], change rows with min and max elements
;result in var array, change N
.model small
.data
    N db 4
    array dw  -1,  -8,  -9,   0
          dw   2,  16,  -3,   1
          dw  13,   2,  -2,  21
          dw  -2,   0,  -6,   0
    len dw 2 ;length word = 2byte
    count dw 0
    min dw ?
    max dw ?
    minInd dw ? ;2
    maxInd dw ? ;11
.stack 256
.code
    mov ax, @data
    mov ds, ax
    xor ax, ax
    xor cx, cx

    mov ax, array[0]
    mov min, ax
    mov max, ax

    mov si, 2 ; ptr rows 1*r=2
    mov al, N
    mul al
    mov cx, ax
    mov count, ax
iterArr: ; calculate min and max
        mov ax, array[si]

        cmp ax, min
        jnl iterMid
        mov min, ax
        mov minInd, si
    iterMid:
        cmp ax, max
        jng iterEnd
        mov max, ax
        mov maxInd, si
    iterEnd:
        add si, len
        loop iterArr

    ;calculate index min row 
    xor ax, ax ; ax=0
    xor bx, bx ; bx=0
    xor dx, dx ; dx=0
    xor bp, bp ; dx=0
    shr minInd, 1 ;word
    mov ax, minInd
    mov bl, N
    cwd
    div bx ;ax ax:dx
    shl bx, 1 ; N * word
    mul bx ; N * word * minRow
    mov bp, ax

    ;calculate index max row 
    xor ax, ax ; ax=0
    xor bx, bx ; bx=0
    xor dx, dx ; dx=0
    shr maxInd, 1 ;word
    mov ax, maxInd
    mov bl, N
    cwd
    div bx ;ax ax:dx
    shl bx, 1 ; N * word
    mul bx ; N * word * maxRow
    mov bx, ax

    cmp bp, bx
    jz exit

    xor si, si
    mov cl, N
changeArr: ; fill cells
        xor ax, ax
        xchg ax, array[si+bx]
        xchg ax, ds:array[si+bp]
        xchg ax, array[si+bx]
        add si, len
        loop changeArr
exit:
    mov ax, 4c00h
    int 21h
end