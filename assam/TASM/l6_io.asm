.model small
.stack 256
.data
    res db 'Result: ', 13, 10, '$'
    CRLF    db  13, 10,'$'

    file_in db 'Enter filename input:', 13, 10, '$'
    file_load db 'File loaded', 13, 10, '$'
    file_err_permission db 'Permission denied', 13, 10, '$'
    file_err_not_found db 'Error file not found', 13, 10, '$'
    file_err_not_found_path db 'Error path not found', 13, 10, '$'
    file_err_open db 'Error open file', 13, 10, '$'
    file_err_read db 'Error read file', 13, 10, '$'
    
    file_out db 'Enter filename output:', 13, 10, '$'
    file_create db 'File created and writed', 13, 10, '$'
    file_open db 'File opend and writed', 13, 10, '$'
    file_err_oc db 'Error open or create file', 13, 10, '$'
    file_err_write db 'Error write file', 13, 10, '$'

    filename db 36 dup(37)

    buf dw 0
.code
.486
    mov ax, @data
    mov ds, ax

    EXTRN print_string:proc

public console_input
;get string from keyboard
;from stack head: str_addr, helper, end
console_input proc near
    pusha
    mov dx, [esp + 16 + 4]
    mov ah, 9
    int 21h

    mov dx, [esp + 16 + 2]
    mov ah,0ah
    int 21h


    xor bx, bx
    mov di, [esp + 16 + 2]
    mov bl, [di + 1]

    xor cx, cx
    cmp [esp + 16 + 6], cx
    jz ci_zero

    mov byte ptr [di + bx + 2], 13
    mov byte ptr [di + bx + 4], 10
    mov byte ptr [di + bx + 6], '$'
    jmp ci_print

    ci_zero:
        mov byte ptr [di + bx + 2], 0

    ci_print:
        mov dx, [esp + 16 + 2]
        add dx, 2
        mov ah, 9
        int 21h

        lea dx, CRLF
        mov ah, 9
        int 21h

    popa
    ret 6
console_input endp

;from stack head: output
public console_output
console_output proc near
    pusha

    push offset res
    call print_string

    mov dx, [esp + 16 + 2]
    push dx
    call print_string

    popa
    ret 2
console_output endp

;from stack head: input
public file_input
file_input proc near
    pusha

    mov buf, 0
    mov cx, cx
    push cx
    push offset file_in
    push offset filename
    call console_input

    mov ah, 3Dh
    mov al, 0 ; open attribute: 0 - read-only, 1 - write-only, 2 -read&amp;write
    lea dx, filename ; ASCIIZ filename to open
    add dx, 2
    int 21h
    jc rf_open_error
    
    mov bx, ax ; handle we get when opening a file
    mov ah, 03Fh       
    mov cx, 0FFFFh ; number of bytes to read
    mov dx, [esp + 16 + 2] ; were to put read data
    int 21h
    jc rf_read_error
    
    mov ah, 03Eh ; close file, bx - handle
    int 21h
    
    xor ebx, ebx
    mov bx, [esp + 16 + 2]
    mov dl, '$'
    mov [ebx + eax], dl
    
    push offset file_load
    call print_string
    jmp rf_return
    
    rf_open_error:
        mov buf, 1
        cmp ax, 2
        jz rf_not_found
        cmp ax, 3
        jz rf_not_found_path
        cmp ax, 5
        jz rf_perm_den

        push offset file_err_open
        call print_string
        jmp rf_return
    rf_not_found:
        push offset file_err_not_found
        call print_string
        jmp rf_return
    rf_not_found_path:
        push offset file_err_not_found_path
        call print_string
        jmp rf_return
    rf_perm_den:
        push offset file_err_permission
        call print_string
        jmp rf_return
    rf_read_error:
        mov buf, 1
        push offset file_err_read
        call print_string
        jmp rf_return

    rf_return:
        popa

        xor dx, dx
        mov dx, buf
        ret 2
file_input endp

public file_output
;from stack head: output
file_output proc near
    pusha
    mov cx, cx
    push cx
    push offset file_out
    push offset filename
    call console_input

    mov buf, 1
    
    wf_open:
        mov ah, 3Dh
        mov al, 1 ; open attribute: 0 - read-only, 1 - write-only, 2 -read&write
        lea dx, filename ; ASCIIZ filename to open
        add dx, 2
        int 21h
        jc wf_create
        jmp wf_write

    wf_write:
        mov ecx, 1
        xor ebx, ebx
        mov bx, [esp + 16 + 2]
        wf_length_loop:
            mov dl, [ebx]
            cmp dl, '$'
            je wf_write_go
            inc ecx
            inc ebx
            jmp wf_length_loop
        
        wf_write_go:
            dec ecx
            mov bx, ax ; handle we get when opening a file
            mov ah, 40h
            mov dx, [esp + 16 + 2] ; data to write
            int 21h
            jc wf_write_error
            
            mov ah, 3Eh ; close file, bx - handle
            int 21h
            jmp wf_status

    wf_create:
        mov buf, 0
        mov ah, 3Ch ; DOS create file
        mov cx, 0 ; attribute
        lea dx, filename ; filename in ASCIIZ
        add dx, 2
        int 21h
        jc wf_oc_error
        jmp wf_open
    
    wf_delete:
        mov bx, ax
        mov ah, 3Eh ; close file, bx - handle
        int 21h
        mov ah, 41h ; delete file
        lea dx, filename ; ASCIIZ filename to delete
        add dx, 2
        int 21h
        jmp wf_create
        
    wf_oc_error:
        cmp ax, 3
        jz wf_not_found
        cmp ax, 4
        jz wf_perm_den

        push offset file_err_oc
        call print_string
        jmp wf_exit
    wf_not_found:
        push offset file_err_not_found_path
        call print_string
        jmp wf_exit
    wf_perm_den:
        push offset file_err_permission
        call print_string
        jmp wf_exit
    wf_write_error:
        mov buf, 3
        jmp wf_status

    wf_status:
        cmp buf, 0
        jz wf_status_create
        cmp buf, 1
        jz wf_status_open
        cmp buf, 2
        jz wf_status_err_oc
        cmp buf, 3
        jz wf_status_err_write
        jmp wf_exit

    wf_status_create:
        push offset file_create
        call print_string
        jmp wf_exit
    wf_status_open:
        push offset file_open
        call print_string
        jmp wf_exit
    wf_status_err_oc:
        push offset file_err_oc
        call print_string
        jmp wf_exit
    wf_status_err_write:
        push offset file_err_write
        call print_string
        jmp wf_exit
    wf_exit:

    popa
    ret 2
file_output endp
end