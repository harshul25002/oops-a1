; NASM x86_64 Linux program using only syscalls (no C/C++ libs)
; - Prompts for name and age
; - Validates age is numeric
; - Asks confirmation y/n
; - Prints whether confirmed

BITS 64

%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_EXIT 60

%define STDIN 0
%define STDOUT 1

section .data
    prompt_name db "Enter your name: ", 0
    prompt_age  db "Enter your age: ", 0
    prompt_conf db "Confirm (y/n): ", 0
    err_age     db "Invalid age (not a number).", 10, 0
    confirmed   db "Confirmed: ", 0
    notconf     db "Not confirmed.", 10, 0
    name_label  db "name=", 0
    age_label   db ", age=", 0
    nl          db 10, 0

section .bss
    name_buf    resb 128
    age_buf     resb 32
    conf_buf    resb 4

section .text
    global _start

_start:
    ; Ask name
    lea rdi, [prompt_name]
    call print_cstr
    mov rdi, STDIN
    lea rsi, [name_buf]
    mov rdx, 127
    call read_line

    ; Ask age
    lea rdi, [prompt_age]
    call print_cstr
    mov rdi, STDIN
    lea rsi, [age_buf]
    mov rdx, 31
    call read_line

    ; Validate age is numeric
    lea rsi, [age_buf]
    call is_numeric
    cmp rax, 1
    jne .invalid_age

    ; Ask confirm
    lea rdi, [prompt_conf]
    call print_cstr
    mov rdi, STDIN
    lea rsi, [conf_buf]
    mov rdx, 3
    call read_line

    ; Check 'y' or 'Y'
    mov al, [conf_buf]
    cmp al, 'y'
    je .print_confirmed
    cmp al, 'Y'
    je .print_confirmed
    jmp .not_confirmed

.print_confirmed:
    lea rdi, [confirmed]
    call print_cstr
    lea rdi, [name_label]
    call print_cstr
    lea rdi, [name_buf]
    call print_cstr
    lea rdi, [age_label]
    call print_cstr
    lea rdi, [age_buf]
    call print_cstr
    lea rdi, [nl]
    call print_cstr
    jmp .exit0

.not_confirmed:
    lea rdi, [notconf]
    call print_cstr
    jmp .exit0

.invalid_age:
    lea rdi, [err_age]
    call print_cstr
    jmp .exit1

.exit0:
    mov rdi, 0
    jmp exit

.exit1:
    mov rdi, 1
    jmp exit

; Reads a line into [rsi] up to rdx-1 bytes, strips trailing \n, NUL-terminates
; Args: rdi=fd, rsi=buf, rdx=maxlen
read_line:
    push rbx
    mov rbx, rsi         ; save buf
    ; read
    mov rax, SYS_READ
    syscall               ; rax=bytes
    cmp rax, 0
    jle .done            ; EOF or error -> empty
    ; rax = count
    mov rcx, rax
    mov rsi, rbx
    xor r8, r8
.find_nl:
    cmp r8, rcx
    jge .no_nl
    mov al, [rsi+r8]
    cmp al, 10
    je .strip
    inc r8
    jmp .find_nl
.strip:
    mov byte [rsi+r8], 0
    jmp .done
.no_nl:
    mov byte [rsi+rcx], 0
.done:
    pop rbx
    ret

; Prints a null-terminated string at rdi
print_cstr:
    push rdi
    mov rsi, rdi
    xor rcx, rcx
.len_loop:
    cmp byte [rsi+rcx], 0
    je .have_len
    inc rcx
    jmp .len_loop
.have_len:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rdx, rcx
    syscall
    pop rdi
    ret

; Returns rax=1 if C-string at rsi is numeric (all digits), else 0
is_numeric:
    xor rax, rax
    xor rcx, rcx
    mov rdx, rsi
    mov bl, 0
.loop:
    mov al, [rdx+rcx]
    cmp al, 0
    je .end
    cmp al, 10
    je .end
    cmp al, '0'
    jb .notnum
    cmp al, '9'
    ja .notnum
    mov bl, 1
    inc rcx
    jmp .loop
.notnum:
    xor rax, rax
    ret
.end:
    movzx rax, bl
    ret

; exit with code in rdi
exit:
    mov rax, SYS_EXIT
    syscall
