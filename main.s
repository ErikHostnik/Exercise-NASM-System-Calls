global _start

section .data
    dir_name    db "28859_Dir", 0
    mode_dir    equ 0o755

    file_name   db "28859_file.dat", 0
    open_flags  equ 0x241        ; O_CREAT|O_TRUNC|O_WRONLY
    file_mode   equ 0o644

    write_flags equ 0x1          ; O_WRONLY
    time_str    db "00-00-00", 0 ; prostor za "HH-MM-SS"

section .text
_start:
    ; --- ustvarjanje imenika in nastavitve fajla ---
    mov eax, 0x27            ; sys_mkdir
    mov ebx, dir_name
    mov ecx, mode_dir
    int 0x80

    mov eax, 0x0c            ; sys_chdir
    mov ebx, dir_name
    int 0x80

    mov eax, 0x05            ; sys_open (CREATE|TRUNC|WRONLY)
    mov ebx, file_name
    mov ecx, open_flags
    mov edx, file_mode
    int 0x80
    mov esi, eax             ; shrani fd v ESI
    mov eax, 0x06            ; sys_close
    mov ebx, esi
    int 0x80

    mov eax, 0x0f            ; sys_chmod
    mov ebx, file_name
    mov ecx, file_mode
    int 0x80

    ; --- odpri za pisanje brez trunc ---
    mov eax, 0x05            ; sys_open
    mov ebx, file_name
    mov ecx, write_flags
    xor edx, edx
    int 0x80
    mov edi, eax             ; shrani fd v EDI

    ; --- vzemi epoch time ---
    mov eax, 0x0d            ; sys_time
    xor ebx, ebx
    int 0x80                 ; EAX = time_t

    ; --- sekunde od začetka dneva ---
    mov ecx, 86400
    xor edx, edx
    div ecx                  ; EAX=celodnevni dnevi, EDX=sekunde-danes
    mov ebp, edx             ; EBP = sekunde danes

    ; --- ure = sek-danes / 3600 ---
    mov eax, ebp
    mov ecx, 3600
    xor edx, edx
    div ecx                  ; EAX=ure, EDX=preostale sek
    mov esi, eax             ; ESI = ure
    mov ebp, edx             ; EBP = preostale sek

    ; --- minute = preostale sek / 60 ---
    mov eax, ebp
    mov ecx, 60
    xor edx, edx
    div ecx                  ; EAX=minute, EDX=sekunde
    mov ebp, edx             ; EBP = sekunde
    push eax                 ; na sklad shrani minute

    ; --- formatiranje v "HH-MM-SS" ---
    mov ebx, time_str

    ; ure
    mov eax, esi
    mov ecx, 10
    xor edx, edx
    div ecx                  ; AL=tenice, DL=enice
    add al, '0'
    mov [ebx], al
    add dl, '0'
    mov [ebx+1], dl
    mov byte [ebx+2], '-'

    ; minute
    pop ecx                  ; obnovi minutes
    mov eax, ecx
    mov ecx, 10
    xor edx, edx
    div ecx                  ; AL=tenice, DL=enice
    add al, '0'
    mov [ebx+3], al
    add dl, '0'
    mov [ebx+4], dl
    mov byte [ebx+5], '-'

    ; sekunde
    mov eax, ebp
    mov ecx, 10
    xor edx, edx
    div ecx                  ; AL=tenice, DL=enice
    add al, '0'
    mov [ebx+6], al
    add dl, '0'
    mov [ebx+7], dl

    ; --- zapiši v datoteko in izhod ---
    mov eax, 0x04            ; sys_write
    mov ebx, edi
    mov ecx, time_str
    mov edx, 8
    int 0x80

    mov eax, 0x06            ; sys_close
    mov ebx, edi
    int 0x80

    mov eax, 0x01            ; sys_exit
    xor ebx, ebx
    int 0x80
