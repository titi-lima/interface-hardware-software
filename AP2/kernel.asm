ORG 0x7C00
BITS 16
    jmp start

start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

;; configurando a ivt
    mov di, 0x100
    mov word[di], print_string
    mov word[di+2], 0

    call get_keyboard_input

    push 0x8000

    int 0x40

end:
    jmp $ ; halt


get_keyboard_input:
    mov di, 0x8000 ; endereço escolhido para armazenar a string
.loop:
    mov ah, 0x00
    int 0x16
    ;; char lido vai estar em al
    mov [di], al
    inc di
    mov ah, 0x0E
    int 0x10
    cmp al, 0x0D
    je .done
    jmp .loop
.done:
    mov al, 0x0A
    mov [di], al
    inc di
    mov ah, 0x0E
    int 0x10
    mov byte[di], 0
    ret

print_string:
    push bp    ;; salvar bp
    mov bp, sp ;; bp -> top da pilha
    mov si, [bp+8]
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    pop bp ;; devolver bp
    iret
; assinatura de boot

    times 510-($-$$) db 0
    dw 0xAA55
