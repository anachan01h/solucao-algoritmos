extern int2str

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

    tree times 64 db 0
    vtree times 8 db 0
    buf times 10 db 0
    space db 0x20
    newline db 0x0A

section .text
global _start

_start:
    mov rdi, graph
    call print
    mov rdi, graph
    mov rsi, tree
    mov rdx, vtree
    mov rcx, 1
    call expand
    mov rdi, tree
    call print
    jmp _exit

    mov rdi, graph
    mov rsi, tree
    mov rdx, vtree
    call mlst

    mov rax, graph
    xor rdi, rdi
    mov dil, [rax + 8]
    mov rsi, buf
    call int2str

    mov rax, 0x01
    mov rdi, 1
    mov rsi, buf
    mov rdx, 10
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
    cmp r8, 8
    jb lineloop

    ret

; mlst(bool *graph, bool *tree, bool *vtree) -> u64
mlst:
    mov r8, rdx
    ; rdi: *graph
    ; rsi: *tree
    ; r8: *vtree
phase1:
    xor r9, r9                  ; r9: v <- 0
case1:
    cmp [r8 + r9], 1
    jne case1_next
    xor rcx, rcx
    xor r10, r10                ; r10: u <- 0
    ; Sugestão do Mô: percorrer os índices de trás pra frente, trocando o cmp por test
case1_loop:
    cmp [r8 + r10], 1
    je case1_loop_next
    mov rax, r9
    mov rdx, 8
    mul rdx
    add rax, r10                ; rax <- v * 8 + u
    cmp [rdi + rax], 1          ; graph(v, u)
    jne case1_loop_next
    inc rcx
    cmp rcx, 2
    jb case1_next
    mov rdx, r8
    mov rcx, r9
    call expand
    jmp phase1

case1_loop_next:
    inc r10
    cmp r10, 8
    jb case1_loop

case1_next:
    inc r9
    cmp r9, 8
    jb case1

    xor r9, r9                  ; r9: v <- 0
case2:
    cmp [r8 + r9], 1
    jne case2_next
    xor rcx, rcx
    xor r10, r10                ; r10: u <- 0
case2_loop1:
    cmp [r8 + r10], 1
    je case2_loop1_next
    mov rax, r9
    mov rdx, 8
    mul rdx                     ; Tá vendo essas instruções? Pra gerar o offset? RODAM  EM TODA ITERAÇÃO DO LOOP!!! PRA QUE???
    add rax, r10                ; rax <- v * 8 + u
    cmp [rdi + rax], 1
    jne case2_loop1_next
    inc rcx

case2_loop1_next:
    inc r10
    cmp r10, 8
    jb case2_loop1

    cmp rcx, 1
    jne case2_next

    xor rcx, rcx                ; rcx: w <- 0
case2_loop2:
    cmp [r8 + rcx], 1
    je case2_loop2_next
    mov rax, r9
    mov rdx, 8
    mul rdx
    add rax, rcx                ; rax <- v * 8 + w
    cmp [rdi + rax], 1
    je case2_loop2_exit
case2_loop2_next:
    inc rcx
    cmp rcx, 8
    jb case2_loop2

case2_loop2_exit:
    push r9
    xor r9, r9
    xor r10, r10                ; r10: u <- 0
case2_loop3:
    cmp [r8 + r10], 1
    je case2_loop3_next
    mov rax, rcx
    mov rdx, 8
    mul rdx
    add rax, r10
    cmp [rdi + rax], 1
    jne case2_loop3_next
    inc r9
    cmp r9, 3
    jb case2_loop3_next
    mov rdx, r8
    call expand
    jmp phase1
case2_loop3_next:
    inc r10
    cmp r10, 8
    jb case2_loop3

case2_next:
    inc r9
    cmp r9, 8
    jb case2

    xor r9, r9                  ; r9: v <- 0
case3:
    cmp [r8 + r9], 1
    jne case3_next
    xor rcx, rcx
    xor r10, r10                ; r10: u <- 0
case3_loop1:
    cmp [r8 + r10], 1
    je case3_loop1_next
    mov rax, r9
    mov rdx, 8
    mul rdx                     ; Tá vendo essas instruções? Pra gerar o offset? RODAM  EM TODA ITERAÇÃO DO LOOP!!! PRA QUE???
    add rax, r10                ; rax <- v * 8 + u
    cmp [rdi + rax], 1
    jne case3_loop1_next
    inc rcx

case3_loop1_next:
    inc r10
    cmp r10, 8
    jb case3_loop1

    cmp rcx, 1
    jne case3_next

    xor rcx, rcx                ; rcx: w <- 0
case3_loop2:
    cmp [r8 + rcx], 1
    je case3_loop2_next
    mov rax, r9
    mov rdx, 8
    mul rdx
    add rax, rcx                ; rax <- v * 8 + w
    cmp [rdi + rax], 1
    je case3_loop2_exit
case3_loop2_next:
    inc rcx
    cmp rcx, 8
    jb case3_loop2

case3_loop2_exit:
    push r9
    xor r9, r9
    xor r10, r10                ; r10: u <- 0
case3_loop3:
    cmp [r8 + r10], 1
    je case3_loop3_next
    mov rax, rcx
    mov rdx, 8
    mul rdx
    add rax, r10
    cmp [rdi + rax], 1
    jne case3_loop3_next
    inc r9
case3_loop3_next:
    inc r10
    cmp r10, 8
    jb case3_loop3

    cmp r9, 2
    jne case4
    mov rdx, r8
    call expand
    jmp phase1

case3_next:
    inc r9
    cmp r9, 8
    jb case2

case4:
    
phase2:
    ret
    

; expand(bool *graph, bool *tree, bool *vtree, u64 v)
expand:
    mov r8, rdx
    ; rdi: *graph
    ; rsi: *tree
    ; r8: *vtree
    ; rcx: v
    or byte [r8 + rcx], 0x01
    xor r9, r9                  ; r9: i <- 0
expand_vloop:
    mov rax, rcx                ; rax <- v
    mov rdx, 8
    mul rdx                     ; rax <- v * 8
    add rax, r9                 ; rax <- v * 8 + i
    mov r10b, [rsi + rax]
    cmp [rdi + rax], r10b
    jbe expand_next1
    or byte [r8 + r9], 0x01
    or byte [rsi + rax], 0x01

expand_next1:
    inc r9
    cmp r9, 8
    jb expand_vloop

    xor r9, r9
expand_loop2:
    mov rax, r9
    mov rdx, 8
    mul rdx
    add rax, rcx
    mov r10b, [rsi + rax]
    cmp [rdi + rax], r10b
    jbe expand_next2
    or byte [rsi + rax], 0x01

expand_next2:
    inc r9
    cmp r9, 8
    jb expand_loop2

    ret
