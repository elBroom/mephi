;f=((a+b)(2c-d^2))/(4(a+e))
;6*3 / 20
;+3ac = 18
.model small
.data
    a dw 1 ;1
    b dw 5
    c dw 6
    d dw 3
    e dw 4 ;4
    r dd ?
    o dd ?
    buf dd ?

.code
.486
    mov ax, @data
    mov ds, ax

    xor eax, eax ; eax=0
    xor ecx, ecx ; ecx=0
    mov ax, a
    mov cx, e
    add ax, cx ; ax=(a+e)
    sal eax, 2 ; ebx=4(a+e)
    jz exit
    mov r, eax ; r=4(a+e)

    xor ecx, ecx ; ecx=0
    mov cx, c
    sal ecx, 1 ; ecx=2c

    xor eax, eax ; eax=0
    mov ax, d
    imul ax ; dx:ax=d^2
    mov bx, dx
    sal bx, 16
    mov bx, ax ; ebx=d^2
    sub ecx, ebx ; ecx=2c-d^2

    xor eax, eax ; eax=0
    xor ebx, ebx ; ebx=0
    mov ax, a
    mov bx, b
    add ax, bx ; ax=(a+b)
    cwde ; eax=(a+b)
    imul ecx ; edx:eax=(a+b)(2c-d^2)

    xor ebx, ebx ; ebx=0
    mov ebx, r
    idiv ebx
    mov r, eax
    mov o, edx

    xor eax, eax ; ebx=0
    xor ebx, ebx ; ebx=0
    mov ax, a ; ax=a
    mov bx, c ; bx=c
    imul bx ; dx:ax=ac

    xor ebx, ebx ; ebx=0
    mov bx, dx
    sal bx, 16
    mov bx, ax ; ebx=ac

    mov buf, ebx
    shl ebx, 1 ; ebx=2ac
    add ebx, buf ; ebx=3ac
    add ebx, r ; ax=r+3ac
    mov r, ebx

exit:
    mov ah, 4ch
    int 21h
end