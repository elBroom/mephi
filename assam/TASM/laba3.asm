;array[N][N], replace (max if elem >= 0 else min)
;result in var array, change N
.model small
.data
    N db 4
    array dw -1,-8,-9,21
          dw 2,16,-3,21
          dw 13,2,-2,-6
          dw -2,0,-6,0
    len dw 2 ;length word = 2byte
    count dw 0
    min dw ?
    max dw ?
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
    iterMid:
        cmp ax, max
        jng iterEnd
        mov max, ax
    iterEnd:
        add si, len
        loop iterArr

    xor si, si
    mov cx, count
fillArr: ; fill cells
        mov ax, array[si]
        cmp ax, 0
        jge fillMax

        mov bx, min
        jmp fillEnd
    fillMax:
        mov bx, max
    fillEnd:
        xchg bx, array[si]
        add si, len
        loop fillArr

    mov ax, 4c00h
    int 21h
end