;array[N][N], change collumns with min and max elements
;result in var array, change N
.model small
.data
    N db 4
    array dw  -1,  -8,  -9,  21
          dw   2,  16,  -3,  21
          dw  13,   2,  -10,  -6
          dw  21,   0,  -6,   0
    len dw 2 ;length word = 2byte
    count dw 0
    raw dw 0
    sum dw 0
    min dw ?
    max dw ?
    minInd dw ? ;2
    maxInd dw ? ;3
    step dw ?
.code
.486
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

    ;calculate step
    xor ax, ax ; eax=0
    mov al, N
    mov step, ax
    shl step, 1 ;word

    xor si, si
    mov cl, N
changeArr: ; calculate sum
        xor ax, ax
        xor bx, bx
        mov bx, raw
        mov ax, array[si+bx]

        add ax, sum
        mov sum, ax

        add bx, len
        mov raw, bx

        add si, step
        loop changeArr
exit:
    mov ax, 4c00h
    int 21h
end