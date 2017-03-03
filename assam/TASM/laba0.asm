.model small
.data
a db 5
b db 7
c db -3
d dw ?
e dw ?

.code
.486
mov ax, @data
mov ds, ax
mov al, a
add al, b
imul al
mov bx, ax
mov al, 3
imul c
xchg ax, bx
cwd
idiv bx
mov d, ax
mov e, dx
mov ah, 4ch
int 21h
end