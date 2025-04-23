

    global _start

section .data
    dir_name    db "28859_Dir", 0
    mode_dir    equ 0o755

section .text
_start:
    ;Ustvarjanje imenika 28859_Dir
    mov eax, 0x27
    mov ebx, dir_name
    mov ecx, mode_dir
    int 0x80


    ;Premik v imenik
    mov eax, 0x0c
    mov ebx, dir_name
    int 0x80

    mov eax, 0x01
    xor ebx, ebx
    int 0x80



