%include "asm_io.inc"

segment .data
    opciones db "Leer un numero:", 10, "1. Decimal", 10, "2. Binario", 10, "3. Octal", 10, "4. Salir", 10, 0
    ingresaD db "Ingresa un numero decimal: ", 0
    ingresaB db "Para ingresar un numero binario, introduzca un digito de 0 a 1 a la vez.", 10, "Del menos significativo al mas significativo.", 10, "Introduzca cualquier otro numero para dejar de ingresar digitos.", 10, 0
    ingresaO db "Para ingresar un numero octal, introduzca un digito de 0 a 7 a la vez.", 10, "Del menos significativo al mas significativo.", 10, "Introduzca cualquier otro numero para dejar de ingresar digitos.", 10, 0
    deci db "Decimal: ", 0
    bina db "Binario: ", 0
    octa db "Octal: ", 0
    hexa db "Hexadecimal: ", 0
    errorOpcion db "Esa opcion no existe", 10, 0
    errorDecimal db "No puede convertir numeros negativos.", 10, 0

segment .bss
    numero resd 1 ;Para almacenar el número decimal a convertir

segment .text
    global asm_main

asm_main:
    enter 0,0
    pusha

menu:
    mov eax, opciones
    call print_string ;Imprime el menú de opciones

    call read_int ;Selecciona una opción
    call print_nl

    cmp eax, 1
        je decimal
    cmp eax, 2
        je binario
    cmp eax, 3
        je octal
    cmp eax, 4
        je salir

    mov eax, errorOpcion
    call print_string ;Imprime error si no se selecciona una opción válida

    jmp menu

decimal:
    mov eax, ingresaD
    call print_string ;Imprime instrucciones para ingresar un número decimal

    call read_int ;Ingresa un número decimal
    cmp eax, 0
        jl decimalNegativo ;lanza error si se introdujo un número negativo
    mov [numero], eax ;para las conversiones de decimal a los otros,
                      ;se debe alterar el valor de eax, entonces es
                      ;necesario guardar el número decimal en otro lado

    call dec_bin ;Decimal a binario
    call dec_oct ;Decimal a octal
    call dec_hex ;Decimal a hexadecimal

    call print_nl
    jmp menu

decimalNegativo:
    mov eax, errorDecimal
    call print_string ;Error por ingresar un número negativo
    call print_nl
    jmp menu

binario:
    mov eax, ingresaB
    call print_string ;Imprime instrucciones para ingresar un número binario

    mov ebx, 0 ;ebx guarda el término del digito que se ingresa
    mov dword [numero], 0 ;Acumula la suma de la conversión binario a decimal
    call bin_dec ;Binario a decimal
    call dec_oct ;Decimal a octal
    call dec_hex ;Decimal a hexadecimal

    call print_nl
    jmp menu

octal:
    mov eax, ingresaO
    call print_string ;"Imprime instrucciones para ingresar un número octal"

    mov ebx, 0 ;ebx guarda el término del digito ingresado
    mov dword [numero], 0 ;acumula la suma de la conversión octal a decimal
    call oct_dec ;Octal a decimal
    call dec_bin ;Decimal a binario
    call dec_hex ;Decimal a hexadecimal

    call print_nl
    jmp menu

dec_bin:
    mov eax, bina
    call print_string ;"Binario: "
    mov eax, [numero]
    mov edx, 0 ;la instrucción idiv divide edx:eax, por lo que edx debe ser 0
               ;para que eax represente el valor correcto a dividir
    mov ebx, 2 ;Divisor
    mov ecx, 0 ;Contador para el stack
    jmp divisionesBinOct

divisionesBinOct:
    idiv ebx ;divide edx:eax sobre ebx
    push edx ;guarda el residuo en el stack
    mov edx, 0
    add ecx, 1 ;incrementa el contador del stack
    cmp eax, 0 ;divide de nuevo si el cociente no es 0
        jne divisionesBinOct
    jmp print_digitos

print_digitos:
    pop eax ;saca del stack el dígito guardado
    call print_int ;imprime ese dígito
    sub ecx, 1 ;decrementa el contador del stack
    cmp ecx, 0 ;si todavía hay dígitos guardados en el stack, repite
        jne print_digitos
    call print_nl
    ret

dec_oct:
    mov eax, octa
    call print_string ;"Octal: "
    mov eax, [numero]
    mov edx, 0 ;la instrucción idiv divide edx:eax, por lo que edx debe ser 0
               ;para que eax represente el valor correcto a dividir
    mov ebx, 8 ;Divisor
    mov ecx, 0 ;Contador para el stack
    jmp divisionesBinOct

dec_hex:
    mov eax, hexa
    call print_string ;"Hexadecimal: "
    mov eax, [numero]
    mov edx, 0 ;la instrucción idiv divide edx:eax, por lo que edx debe ser 0
               ;para que eax represente el valor correcto a dividir
    mov ebx, 16 ;Divisor 
    mov ecx, 0 ;Contador para el stack
    jmp divisionesHex

divisionesHex:
    idiv ebx ;divide edx:eax sobre ebx
    push edx ;guarda el residuo en el stack
    mov edx, 0
    add ecx, 1 ;incrementa el contador del stack
    cmp eax, 0 ;divide de nuevo si el cociente no es 0
        jne divisionesHex
    jmp print_digitosHex

print_digitosHex: 
    pop eax ;saca del stack el dígito guardado
    sub ecx, 1 ;decrementa el contador del stack
    ;Casos de que el dígito sea de 10 a 15 (A a F)
    cmp eax, 10
        je hex_A
    cmp eax, 11
        je hex_B
    cmp eax, 12
        je hex_C
    cmp eax, 13
        je hex_D
    cmp eax, 14
        je hex_E
    cmp eax, 15
        je hex_F
    call print_int ;Imprime el dígito numérico si es 9 o menor
    jmp salirHex 

hex_A:
    mov eax, 'A'
    call print_char
    jmp salirHex

hex_B:
    mov eax, 'B'
    call print_char
    jmp salirHex

hex_C:
    mov eax, 'C'
    call print_char
    jmp salirHex

hex_D:
    mov eax, 'D'
    call print_char
    jmp salirHex

hex_E:
    mov eax, 'E'
    call print_char
    jmp salirHex

hex_F:
    mov eax, 'F'
    call print_char
    jmp salirHex

salirHex:
    cmp ecx, 0 ;si todavía hay dígitos guardados en el stack, repite
        jne print_digitosHex
    call print_nl
    ret

bin_dec:
    call read_int ;lee un dígito a la vez
    ;Salir si el dígito ingresado no es 0 ni 1
    cmp eax, 0
        jl salirBinOct
    cmp eax, 1
        jg salirBinOct
    ;El primer dígito sólo se suma al acumulador
    cmp ebx, 0
        je primer_terminoBin

    mov ecx, 0 ;Cuenta el número de ciclos a hacer por término
    jmp otros_terminosBin

salirBinOct:
    mov eax, deci
    call print_string ;"Decimal: "
    mov eax, [numero]
    call print_int ;Imprime el número decimal convertido de binario/octal
    call print_nl
    ret

primer_terminoBin:
    add [numero], eax
    add ebx, 1 ;Avanza al siguiente término/dígito
    jmp bin_dec

otros_terminosBin: ;dígito*2^n (dígito = eax, n = ebx)
    imul eax, eax, 2 ;eax = eax*2
    add ecx, 1 ;Incrementa el contador del ciclo
    cmp ecx, ebx
        jne otros_terminosBin
    jmp primer_terminoBin

oct_dec:
    call read_int ;lee un dígito a la vez
    ;Salir si el dígito ingresado no es de 0 a 7
    cmp eax, 0
        jl salirBinOct
    cmp eax, 7
        jg salirBinOct
    ;El primer dígito sólo se suma al acumulador
    cmp ebx, 0
        je primer_terminoOct
    mov ecx, 0 ;Cuenta el numero de ciclos a hacer por término
    jmp otros_terminosOct

primer_terminoOct:
    add [numero], eax
    add ebx, 1 ;Avanza al siguiente término/dígito
    jmp oct_dec

otros_terminosOct: ;dígito*8^n (dígito = eax, n = ebx)
    imul eax, eax, 8 ;eax = eax*8
    add ecx, 1 ;Incrementa el contador del ciclo
    cmp ecx, ebx
        jne otros_terminosOct
    jmp primer_terminoOct

salir:
    popa
    mov eax, 0
    leave
    ret
