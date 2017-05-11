.model small
.stack 256
.data
    buf dw 0
.code
.486
    mov ax, @data
    mov ds, ax

    EXTRN concat_count:proc

;from stack head: from_file, input, output
public base
base proc near
    pusha
        xor cx, cx
        mov cx, [esp + 16 + 2]

        xor dx, dx
        mov buf, 0

        mov si, [esp + 16 + 4] ; source
        mov di, [esp + 16 + 6] ; distination
        dec si

        cmp cx, '1'
        jnz b_findWord
        add si, 2

    b_findWord:
        inc si
        mov al, '$' ; check EOF
        cmp al, [si]
        jz b_exit
        mov al, ' ' ; check space
        cmp al, [si]
        jz b_chkLen
        mov al, 13 ; check end line
        cmp al, [si]
        jz b_chkLen
        inc dx ;count symbols
        jmp b_findWord

    b_chkLen:
        cmp dx, 0
        jz b_newLine

        cmp buf, 1
        jnz b_addLen
        mov al, '.'
        stosb ; add point

    b_addLen:
        call concat_count

        inc buf
        xor dx, dx
        xor ax, ax

    b_newLine:
        mov al, ' ' ; check space
        cmp al, [si]
        jz b_findWord

        mov al, 10
        cmp al, [di-1]
        jnz b_endLine

    b_setZero:
        mov al, '0'
        stosb ; add end line

    b_endLine:
        mov al, '$'
        cmp al, [di-1]
        jz b_setZero

        mov al, 13
        stosb ; add end line
        mov al, 10
        stosb ; add end line
        mov buf, 0
        inc si
        jmp b_findWord

    b_exit:
        stosb ; add EOF

    popa
    ret 6
base  endp

;from stack head: from_file, input, output
public additionally
additionally proc near
    pusha
        xor dx, dx
        mov buf, 0

        xor cx, cx
        mov cx, [esp + 16 + 2]

        xor dx, dx
        mov buf, 0

        mov si, [esp + 16 + 4] ; source
        mov di, [esp + 16 + 6] ; distination
        dec si

        cmp cx, '1'
        jnz b_findWord
        add si, 2

    a_findWord:
        inc si
        mov al, '$' ; check EOF
        cmp al, [si]
        jz a_exit
        mov al, ' ' ; check space
        cmp al, [si]
        jz a_chkLen
        mov al, 13 ; check end line
        cmp al, [si]
        jz a_chkLen
        inc dx ;count symbols
        jmp a_findWord

    a_chkLen:
        cmp dx, buf
        jng a_newWord
        mov buf, dx

    a_newWord:
        xor edx, edx
        mov al, ' ' ; check space
        cmp al, [si]
        jz a_findWord

        mov dx, buf
        call concat_count

        mov al, ' '
        stosb ; add end line
        mov buf, 0
        xor edx, edx
        inc si
        jmp a_findWord

    a_exit:
        mov al, 13
        stosb ; add end line
        mov al, 10
        stosb ; add end line
        mov al, '$'
        stosb ; add EOF

    popa
    ret 6
additionally  endp
end