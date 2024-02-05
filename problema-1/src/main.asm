    section .data
n dq 4
c dq 5
p dq 4, 2, 1, 3
v dq 500, 400, 300, 450

    section .bss
buf resb 10
X resq 30                     ; 5 linhas, 6 colunas

    section .text
    global _start

_start:
    mov rcx, 0                  ; rcx: b <- 0
    mov rdi, X
_loop1:
    mov qword [rdi + rcx * 8], 0    ; X[0, b] <- 0
    mov r10, 1                  ; rdx: j <- 1
_loop2:
    mov rax, r10                ; rax <- j
    dec rax                     ; rax <- j - 1
    mov rbx, 6                  ; Parâmetro da quantidade de linhas de X
    mul rbx                     ; rax <- (j - 1) * 6
    add rax, rcx                ; rax <- (j - 1) * 6 + b
    mov r8, [rdi + rax * 8]         ; r8 <- X[j - 1, b]
    mov rsi, p
    cmp rcx, [rsi + r10 * 8 - 8]    ; se b < p[j - 1]
    jb _next

    mov rax, r10                ; rax <- j
    dec rax                     ; rax <- j - 1
    mov rbx, 6                  ; Parâmetro da quantidade de linhas de X
    mul rbx                     ; rax <- (j - 1) * 6
    add rax, rcx                ; rax <- (j - 1) * 6 + b
    sub rax, [rsi + r10 * 8 - 8]    ; rax <- (j - 1) * 6 + b - p[j - 1]
    mov r9, [rdi + rax * 8]         ; r9 <- X[j - 1, b - p[j - 1]]
    mov rsi, v
    add r9, [rsi + r10 * 8 - 8]     ; r9 <- X[j - 1, b - p[j - 1]] + v[j - 1]
    cmp r8, r9                  ; se r8 < r9
    cmovb r8, r9

_next:
    mov rax, r10                ; rax <- j
    mov rbx, 6                  ; Parâmetro da quantidade de linhas de X
    mul rbx                     ; rax <- j * 6
    add rax, rcx                ; rax <- j * 6 + b
    mov [rdi + rax * 8], r8

    inc r10
    cmp r10, [n]
    jbe _loop2

    inc rcx
    cmp rcx, [c]
    jbe _loop1

    mov rdi, [rdi + 22 * 8]
    mov rsi, buf
    call int2str

    mov rax, 0x01
    mov rdi, 1
    mov rsi, buf
    mov rdx, 10
    syscall

    mov rdi, rax
    mov rax, 3Ch
    ;; mov rdi, [rdi + 29]
    syscall

; void int2str(long n, char *buf)
int2str:
    xor rdx, rdx
    mov rax, rdi
    mov r8, 10
    div r8
    test rax, rax
    jz int2str_next
    mov rdi, rax
    push rdx
    call int2str
    pop rdx

int2str_next:
    add dl, 0x30
    mov [rsi], dl
    inc rsi
    ret
