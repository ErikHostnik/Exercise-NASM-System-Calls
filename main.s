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
    ; Ustvarjanje imenika 28859_Dir
    mov eax, 0x27
    mov ebx, dir_name
    mov ecx, mode_dir
    int 0x80

    ; Premik v imenik
    mov eax, 0x0c
    mov ebx, dir_name
    int 0x80

    ; Ustvarjanje datoteke
    mov eax, 0x05
    mov ebx, file_name
    mov ecx, open_flags
    mov edx, file_mode
    int 0x80
    mov esi, eax        ; shranimo fd
    ; Zapri datoteko
    mov eax, 0x06
    mov ebx, esi
    int 0x80

    ; Nastavljanje pravic
    mov eax, 0x0f
    mov ebx, file_name
    mov ecx, file_mode
    int 0x80



    ; Odpri datoteko za pisanje (brez trunc, samo O_WRONLY)
    mov eax, 0x05
    mov ebx, file_name
    mov ecx, write_flags
    mov edx, 0         
    int 0x80
    mov ebx, eax       

    ;sys_time
    mov eax, 0x02
    xor ebx, ebx       
    int 0x80
    

    ; Izračun sekund
    mov ecx, 86400
    xor edx, edx
    div ecx            
    mov eax, edx       

    ; Izračun ur
    mov ecx, 3600
    xor edx, edx
    div ecx            
    mov esi, eax      

    ; Izračun minut
    mov eax, edx       
    mov ecx, 60
    xor edx, edx
    div ecx            
    mov edi, eax      
    mov edx, edx      

    ; Pretvorba v ASCII in shranjevanje v time_str
    mov ebx, time_str

    ; ure: desetice
    mov eax, esi
    mov ecx, 10
    xor edx, edx
    div ecx            
    add al, '0'
    mov [ebx], al
    
    ; ure: enice
    add dl, '0'
    mov [ebx+1], dl
    ; vezaj
    mov byte [ebx+2], '-'

    ; minute: desetice
    mov eax, edi
    mov ecx, 10
    xor edx, edx
    div ecx
    add al, '0'
    mov [ebx+3], al
    
    ; minute: enice
    add dl, '0'
    mov [ebx+4], dl
    ; vezaj
    mov byte [ebx+5], '-'

    ; sekunde: desetice
    mov eax, edx
    mov ecx, 10
    xor edx, edx
    div ecx
    add al, '0'
    mov [ebx+6], al

    ; sekunde: enice
    add dl, '0'
    mov [ebx+7], dl

    ; Zapiši 8 bajtov iz time_str
    mov eax, 0x04      


    ; ebx že vsebuje fd
    mov ecx, time_str
    mov edx, 8
    int 0x80

    ; Zapri datoteko
    mov eax, 0x06
    int 0x80

    ; Izhod
    mov eax, 0x01
    xor ebx, ebx
    int 0x80
