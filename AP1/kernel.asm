; comentarios

ORG 0x7C00
BITS 16
    jmp start

msg: db "Essa mensagem tem, ao todo, 13 vogais", 0x0D, 0x0A, 0
display_string: db "Numero de vogais: ", 0

start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov si, display_string
    call print_string
    mov si, msg
    call count_vowels
    mov ax, cx
    call print_number

count_vowels:
    mov cx, 0
    .loop:
        lodsb
        or al, al ; checa se acabou a string
        jz .done
        cmp al, 'a'
        je .vowel
        cmp al, 'e'
        je .vowel
        cmp al, 'i'
        je .vowel
        cmp al, 'o'
        je .vowel
        cmp al, 'u'
        je .vowel
        cmp al, 'A'
        je .vowel
        cmp al, 'E'
        je .vowel
        cmp al, 'I'
        je .vowel
        cmp al, 'O'
        je .vowel
        cmp al, 'U'
        je .vowel
        jmp .loop
    .vowel:
        inc cx ; incrementa o contador a cada vogal encontrada
        jmp .loop
    .done:
        mov ax, cx
        ret

end:
    jmp $ ; halt


print_string:
    .loop:
        lodsb
        or al, al
        jz .done
        mov ah, 0x0E
        int 0x10
        jmp .loop
    .done:
        ret

print_number:
    mov bx, 10
    mov cx, 0
    .loop1:
        mov dx, 0
        div bx
        ; resposta vai ta no ax, resto no dx
        add dx, 48
        push dx
        inc cx
        cmp ax, 0
        jne .loop1
    .loop2:
        pop ax
        mov ah, 0x0E
        int 0x10
        loop .loop2
    .done:
        ret

; assinatura de boot

    times 510-($-$$) db 0
    dw 0xAA55
