    section .text
    global _start
    
_start:
    pop rdi
    cmp rdi, 2
    jl .missing_arg
    pop rdi
    pop rdi
    mov rax, rdi
    mov rsi, help_str
    mov rcx, help_str_len
    repe cmpsb
    mov rdi, rax
    je .show_help
    mov rcx, -1

.loop:
    inc rcx
    mov al, byte [rdi+rcx]
    mov byte [filename+rcx], al
    test al, al
    jnz .loop
    inc rcx
    mov dword [filename_len], ecx
    call read_file
    call mint_start
    xor rdi, rdi
    call exit

.missing_arg:
    mov rax, 1
    mov rdi, 1
    mov rsi, missing_arg_msg
    mov rdx, missing_arg_msg_len
    syscall
    mov rdi, 1
    call exit

.show_help:
    mov rax, 1
    mov rdi, 1
    mov rsi, help_msg
    mov rdx, help_msg_len
    syscall
    mov rdi, 1
    call exit

; in:
; - rdi: exit code
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; in:
; - al: character
; out:
; - rdi: 0 = true, 1 = false
isspace:
    cmp al, ' '
    je .true
    cmp al, 10 ; \n
    je .true
    cmp al, 9 ; \t
    je .true
    cmp al, 13 ; \r
    je .true
    mov rdi, 1
    ret
.true:
    xor rdi, rdi
    ret

; in:
; - al: character
; out:
; - rdi: 0 = true, 1 = false
isalpha:
    cmp al, 'A'
    jl .false
    cmp al, 'z'
    jg .false
    xor rdi, rdi
    ret
.false:
    mov rdi, 1
    ret

; in:
; - al: character
; out:
; - rdi: 0 = true, 1 = false
isdigit:
    cmp al, '0'
    jl .false
    cmp al, '9'
    jg .false
    xor rdi, rdi
    ret
.false:
    mov rdi, 1
    ret

read_file:
    mov rax, 2
    mov rdi, filename
    xor rsi, rsi
    syscall
    cmp rax, 0
    jl .open_fail
    push rax
    mov rdi, rax
    xor rax, rax
    mov rsi, src
    mov rdx, SRC_CAP-1
    syscall
    cmp rax, 0
    jl .read_fail
    mov byte [src+SRC_CAP-1], 0
    mov rax, 3
    pop rdi
    syscall
    cmp rax, 0
    jl .close_fail
    ret

.open_fail:
    mov rax, 1
    mov rdi, 1
    mov rsi, open_fail_msg
    mov rdx, open_fail_msg_len
    syscall
    mov rdi, 1
    call exit

.read_fail:
    mov rax, 1
    mov rdi, 1
    mov rsi, read_fail_msg
    mov rdx, read_fail_msg_len
    syscall
    mov rdi, 1
    call exit

.close_fail:
    mov rax, 1
    mov rdi, 1
    mov rsi, close_fail_msg
    mov rdx, close_fail_msg_len
    syscall
    mov rdi, 1
    call exit

; in:
; - rdi: string pointer
; out:
; - rax: converted number
atoi:
    push rcx
    push rbx
    xor rcx, rcx
    xor rbx, rbx

.loop:
    mov al, byte [rdi+rcx]
    test al, al
    jz .done
    sub rax, '0'
    imul rbx, 10
    add rbx, rax
    inc rcx
    jmp .loop

.done:
    mov rax, rbx
    pop rbx
    pop rcx
    ret

; in:
; - rdi: number to convert
; out:
; - buf: converted string
; - rcx: string length
itoa:
    test rdi, rdi
    jnz .not_zero
    mov byte [buf], '0'
    mov byte [buf+1], 0
    ret

.not_zero:
    push rax
    push rbx
    push rdx
    push rsi
    push r8
    push r9
    mov rbx, 10
    xor rcx, rcx
    xor r8, r8
    cmp rdi, 0
    jge .loop
    mov r8, 1
    neg rdi

.loop:
    cmp rdi, 0
    je .loop_done
    mov rax, rdi
    xor rdx, rdx
    idiv rbx
    cmp rdx, 9
    jg .above_nine
    add rdx, '0'
    jmp .add_done

.above_nine:
    add rdx, 87 ; (remainder - 10) + 'a'

.add_done:
    mov byte [buf+rcx], dl
    inc rcx
    mov rax, rdi
    cqo
    idiv rbx
    mov rdi, rax
    jmp .loop

.loop_done:
    test r8, r8
    jz .positive
    mov byte [buf+rcx], '-'
    inc rcx

.positive:
    mov byte [buf+rcx], 0
    xor rbx, rbx
    mov rdx, rcx
    dec rdx

.reverse_loop:
    cmp rbx, rdx
    jge .done
    mov sil, byte [buf+rbx]
    mov r9b, byte [buf+rdx]
    mov byte [buf+rbx], r9b
    mov byte [buf+rdx], sil
    dec rdx
    inc rbx

.done:
    pop r9
    pop r8
    pop rsi
    pop rdx
    pop rbx
    pop rax
    ret

mint_start:
    xor rcx, rcx

.loop:
    mov al, byte [src+rcx]
    test al, al
    jz .done
    call isspace
    test rdi, rdi
    jz .next
    xor r8, r8
    mov r9, TOK_ID
    call isalpha
    test rdi, rdi
    jz .parse
    mov r9, TOK_DIGIT
    call isdigit
    test rdi, rdi
    jz .parse
    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, unknown_ch_msg
    mov rdx, unknown_ch_msg_len
    syscall
    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp]
    mov rdx, 1
    syscall
    mov byte [rsp], 10
    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp]
    mov rdx, 1
    syscall
    add rsp, 8
    mov rdi, 1
    call exit

.parse:
    mov al, byte [src+rcx]
    test al, al
    jz .parse_done
    call isspace
    test rdi, rdi
    jz .parse_done
    mov byte [buf+r8], al
    inc rcx
    inc r8
    jmp .parse

.parse_done:
    cmp r9, TOK_DIGIT
    je .do_digit
    push rsi
    push rcx
    mov rsi, buf
    mov rdi, dup_str
    mov rcx, 3
    repe cmpsb
    je .do_dup
    mov rsi, buf
    mov rdi, drop_str
    mov rcx, 4
    repe cmpsb
    je .do_drop
    mov rsi, buf
    mov rdi, out_str
    mov rcx, 3
    repe cmpsb
    je .do_out
    mov rsi, buf
    mov rdi, over_str
    mov rcx, 4
    repe cmpsb
    je .do_over
    mov rsi, buf
    mov rdi, swap_str
    mov rcx, 4
    repe cmpsb
    je .do_swap
    mov rax, 1
    mov rdi, 1
    mov rsi, unknown_id_msg
    mov rdx, unknown_id_msg_len
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    mov rdx, r8
    syscall
    mov byte [rsp], 10
    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp]
    mov rdx, 1
    syscall
    add rsp, 8
    mov rdi, 1
    call exit

.do_dup:
    cmp dword [stack_ptr], STACK_CAP
    jge .stack_overflow
    mov esi, dword [stack_ptr]
    dec esi
    mov rdi, qword [stack+rsi*8]
    mov esi, dword [stack_ptr]
    mov qword [stack+rsi*8], rdi
    add dword [stack_ptr], 1
    jmp .id_done

.do_drop:
    cmp dword [stack_ptr], 0
    jle .stack_underflow
    sub dword [stack_ptr], 1
    jmp .id_done

.do_out:
    cmp dword [stack_ptr], 0
    jle .stack_underflow
    mov esi, dword [stack_ptr]
    dec rsi
    mov rdi, qword [stack+rsi*8]
    call itoa
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    mov rdx, rcx
    syscall
    push 10
    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp]
    mov rdx, 1
    syscall
    add rsp, 8
    sub dword [stack_ptr], 1
    jmp .id_done

.do_over:
    cmp dword [stack_ptr], 1
    jle .stack_underflow
    cmp dword [stack_ptr], STACK_CAP
    jge .stack_overflow
    mov esi, dword [stack_ptr]
    sub esi, 2
    mov rdi, qword [stack+rsi*8]
    mov esi, dword [stack_ptr]
    mov qword [stack+rsi*8], rdi
    add dword [stack_ptr], 1
    jmp .id_done

.do_swap:
    cmp dword [stack_ptr], 1
    jle .stack_underflow
    mov esi, dword [stack_ptr]
    dec esi
    mov rdi, qword [stack+rsi*8]
    dec esi
    mov rdx, qword [stack+rsi*8]
    inc esi
    mov qword [stack+rsi*8], rdx
    dec esi
    mov qword [stack+rsi*8], rdi
    jmp .id_done

.id_done:
    pop rcx
    pop rsi
    jmp .next

.do_digit:
    cmp dword [stack_ptr], STACK_CAP
    jge .stack_overflow
    mov rdi, buf
    call atoi
    mov edi, dword [stack_ptr]
    mov qword [stack+rdi*8], rax
    add dword [stack_ptr], 1

.next:
    inc rcx
    jmp .loop

.stack_underflow:
    mov rax, 1
    mov rdi, 1
    mov rsi, stack_underflow_msg
    mov rdx, stack_underflow_msg_len
    syscall
    mov rdi, 1
    call exit

.stack_overflow:
    mov rax, 1
    mov rdi, 1
    mov rsi, stack_overflow_msg
    mov rdx, stack_overflow_msg_len
    syscall
    mov rdi, 1
    call exit

.done:
    ret

    section .data
missing_arg_msg: db "error: missing argument <input file>",10,0
missing_arg_msg_len equ $-missing_arg_msg
help_str: db "--help"
help_str_len equ $-help_str
help_msg: db "usage: mint <input file>",10,0
help_msg_len equ $-help_msg
open_fail_msg: db "error: failed to open file",10,0
open_fail_msg_len equ $-open_fail_msg
read_fail_msg: db "error: failed to read file",10,0
read_fail_msg_len equ $-read_fail_msg
close_fail_msg: db "error: failed to close file",10,0
close_fail_msg_len equ $-close_fail_msg
unknown_ch_msg: db "error: unknown character: ",0
unknown_ch_msg_len equ $-unknown_ch_msg
unknown_id_msg: db "error: unknown identifier: ",0
unknown_id_msg_len equ $-unknown_id_msg
stack_underflow_msg: db "error: stack underflow",10,0
stack_underflow_msg_len equ $-stack_underflow_msg
stack_overflow_msg: db "error: stack underflow",10,0
stack_overflow_msg_len equ $-stack_overflow_msg
dup_str: db "dup"
drop_str: db "drop"
out_str: db "out"
over_str: db "over"
swap_str: db "swap"
STACK_CAP equ 64
stack: times STACK_CAP dq 0
stack_ptr: dd 0
SRC_CAP equ 1024
BUF_CAP equ 64
TOK_ID equ 1
TOK_DIGIT equ 2

    section .bss
filename: resb 64
filename_len: resd 0
src: resb SRC_CAP
buf: resb BUF_CAP
