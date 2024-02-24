section .text
global int2str

; void int2str(long n, char *buf)
int2str:
    xor rdx, rdx
    mov rax, rdi
    mov r8, 10
    div r8
    test rax, rax
    jz _next
    mov rdi, rax
    push rdx
    call int2str
    pop rdx

_next:
    add dl, 0x30
    mov [rsi], dl
    inc rsi
    ret
