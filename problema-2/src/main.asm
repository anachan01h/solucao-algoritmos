extern int2str
extern mcds

section .data
    graph:
    db 0, 1, 0, 0, 0, 0, 0, 0
    db 1, 0, 1, 0, 0, 0, 0, 0
    db 0, 1, 0, 1, 0, 0, 0, 0
    db 0, 0, 1, 0, 1, 0, 0, 0
    db 0, 0, 0, 1, 0, 1, 0, 0
    db 0, 0, 0, 0, 1, 0, 1, 0
    db 0, 0, 0, 0, 0, 1, 0, 1
    db 0, 0, 0, 0, 0, 0, 1, 0

    db 0, 1, 0, 0, 1, 0, 0, 0
    db 1, 0, 1, 0, 0, 0, 0, 0
    db 0, 1, 0, 1, 0, 0, 0, 0
    db 0, 0, 1, 0, 1, 0, 0, 0
    db 1, 0, 0, 1, 0, 1, 0, 0
    db 0, 0, 0, 0, 1, 0, 1, 0
    db 0, 0, 0, 0, 0, 1, 0, 1
    db 0, 0, 0, 0, 0, 0, 1, 0

    covered times 8 db 0
    cds times 8 db 0
    buf times 10 db 0
    space db 0x20
    newline db 0x0A

section .text
global _start

_start:
    mov rdi, 8
    mov rsi, graph
    mov rdx, covered
    mov rcx, cds
    call mcds
    mov rdi, rax
    sub rdi, 8
    neg rdi
    mov rsi, buf
    call int2str

    mov rax, 0x01
    mov rdi, 1
    mov rsi, buf
    mov rdx, 10
    syscall
    mov rax, 0x01
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

_exit:
    mov rax, 0x3C
    xor rdi, rdi
    syscall

print:
    xor r8, r8
lineloop:
    xor r9, r9
colloop:
    mov rax, r8
    mov rdx, 8
    mul rdx
    add rax, r9
    xor rcx, rcx
    mov cl, [rdi + rax]
    push rdi
    push r8
    push r9
    mov rdi, rcx
    mov rsi, buf
    call int2str

    mov rax, 0x01
    mov rdi, 1
    mov rsi, buf
    mov rdx, 10
    syscall

    mov rax, 0x01
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

    pop r9
    pop r8
    pop rdi

    inc r9
    cmp r9, 8
    jb colloop

    push rdi
    push r8
    push r9
    mov rax, 0x01
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    pop r9
    pop r8
    pop rdi

    inc r8
    cmp r8, 1
    jb lineloop

    ret


; mcds(bool *graph, bool *covered, bool *cds) -> u64
mcds2:
    mov r8, rdx
    ; rdi: *graph
    ; rsi: *covered
    ; r8: *cds
    sub rsp, 16
    ; rsp: vertex
    ; rsp + 8: vizinhos
    mov qword [rsp], 0
    mov qword [rsp + 8], 0
    xor r9, r9                  ; r9: v <- 0
mcds_loop01:
    xor rcx, rcx                ; rcx: u <- 0
    xor r10, r10
mcds_loop02:
    mov rax, r9
    mov rdx, 8
    mul rdx
    add rax, rcx
    cmp byte [rdi + rax], 1
    jne mcds_loop02_next
    inc r10
mcds_loop02_next:
    inc rcx
    cmp rcx, 8
    jb mcds_loop02
    cmp [rsp + 8], r10
    jae mcds_loop01_next
    mov [rsp], r9
    mov [rsp + 8], r10
mcds_loop01_next:
    inc r9
    cmp r9, 8
    jb mcds_loop01

    mov r9, [rsp]
    or byte [rsi + r9], 0x01
mcds_loop1:
    mov qword [rsp], 0                ; vertex <- 0
    mov qword [rsp + 8], 0            ; vizinhos <- 0
    xor r9, r9                  ; r9: v <- 0
mcds_select:
    cmp byte [rsi + r9], 1      ; v not in covered
    jne mcds_select_next
    cmp byte [r8 + r9], 1       ; v in cds
    je mcds_select_next
    xor rcx, rcx                ; rcx: u <- 0
    xor r10, r10
mcds_vizinhos:
    cmp byte [rsi + rcx], 1
    je mcds_vizinhos_next
    mov rax, r9
    mov rdx, 8
    mul rdx
    add rax, rcx                ; rax <- v * 8 + u
    cmp byte [rdi + rax], 1
    jne mcds_vizinhos_next
    inc r10
mcds_vizinhos_next:
    inc rcx
    cmp rcx, 8
    jb mcds_vizinhos
    cmp [rsp + 8], r10
    jae mcds_select_next
    mov [rsp], r9
    mov [rsp + 8], r10
mcds_select_next:
    inc r9
    cmp r9, 8
    jb mcds_select

    mov r9, [rsp]
    or byte [r8 + r9], 0x01
    xor rcx, rcx                ; rcx: u <- 0
mcds_loop2:
    cmp byte [rsi + rcx], 1
    je mcds_loop2_next
    mov rax, r9
    mov rdx, 8
    mul rdx
    add rax, rcx
    cmp byte [rdi + rax], 1
    jne mcds_loop2_next
    or byte [rsi + rcx], 0x01
mcds_loop2_next:
    inc rcx
    cmp rcx, 8
    jb mcds_loop2

    xor rcx, rcx
mcds_loop3:
    cmp byte [rsi + rcx], 1
    jne mcds_loop1
    inc rcx
    cmp rcx, 8
    jb mcds_loop3

    xor rcx, rcx
    xor rax, rax
mcds_loop4:
    cmp byte [r8 + rcx], 1
    jne mcds_loop4_next
    inc rax
mcds_loop4_next:
    inc rcx
    cmp rcx, 8
    jb mcds_loop4

    add rsp, 16
    ret
