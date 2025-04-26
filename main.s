

    global _start

section .data
    dir_name    db "28859_Dir", 0
    mode_dir    equ 0o755

    file_name   db "28859_file.dat", 0
    open_flags  equ 0x241
    file_mode   equ 0o644

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


    ;Ustvarjanje datoteke
    mov eax, 0x05
    mov ebx, file_name
    mov ecx, open_flags
    mov edx, file_mode
    int 0x80
    mov esi, eax

<<<<<<< HEAD

=======
    ;zapri datoteko
    mov eax, 0x06
    mov ebx, esi
    int 0x80

    ;Nastavljanje pravicc
    mov eax, 0x0f
    mov ebx, file_name
    mov ecx, file_mode
    int 0x80


    ;izhod
>>>>>>> a96ef1f (NS-5 Nastavitev dovoljenj)
    mov eax, 0x01
    xor ebx, ebx
    int 0x80

<<<<<<< HEAD
=======
    

>>>>>>> a96ef1f (NS-5 Nastavitev dovoljenj)

