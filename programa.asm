; -------------------------------------------------------------------
; programa.asm - Laboratorio Post 1 Unidad 4
; Propósito: Demostrar directivas de sección, datos y constantes [cite: 81, 83]
; -------------------------------------------------------------------

; Constantes (EQU - no reservan memoria) [cite: 86]
CR          EQU 0Dh          ; Carriage Return [cite: 87]
LF          EQU 0Ah          ; Line Feed [cite: 88]
TERMINADOR  EQU 24h          ; '$' terminador de cadena para DOS [cite: 89]
ITERACIONES EQU 5            ; Número de repeticiones del bucle [cite: 90]

; -------------------------------------------------------------------
section .data                ; Datos inicializados [cite: 92, 93]
; -------------------------------------------------------------------
bienvenida  db "=== Laboratorio NASM Unidad 4 ===", CR, LF, TERMINADOR [cite: 97, 101]
separador   db "---------------------------------", CR, LF, TERMINADOR [cite: 99, 100]
etiqueta_a  db "Variable A (byte): ", TERMINADOR [cite: 102]
fin_msg     db CR, LF, "Programa finalizado correctamente.", CR, LF, TERMINADOR [cite: 104, 107]

; Tipos de datos demostrados [cite: 108]
var_byte    db 42            ; 1 byte con valor 42 (ASCII de '*') [cite: 110, 111]
var_word    dw 1234h         ; 2 bytes con valor 0x1234 [cite: 112, 114]
var_dword   dd 0DEADBEEFh    ; 4 bytes [cite: 115, 117]
tabla_bytes db 10, 20, 30, 40, 50 ; 5 bytes consecutivos [cite: 119, 120]

; -------------------------------------------------------------------
section .bss                 ; Datos no inicializados [cite: 122, 123]
; -------------------------------------------------------------------
buffer      resb 80          ; 80 bytes para entrada [cite: 124, 125]
resultado   resw 1           ; 1 word para cálculos [cite: 126, 127]

; -------------------------------------------------------------------
section .text                ; Código ejecutable [cite: 131, 132]
; -------------------------------------------------------------------
global main

main:
    ; Inicializar registro de segmento de datos [cite: 134, 135]
    mov ax, @data            ; Obtener dirección del segmento de datos [cite: 136, 138]
    mov ds, ax               ; DS apunta a la sección de datos [cite: 137, 139]

    ; --- PASO 3: Imprimir bienvenida ---
    mov ah, 09h              ; Función DOS: imprimir cadena [cite: 141, 144]
    mov dx, bienvenida       ; DX dirección del mensaje [cite: 142, 145]
    int 21h                  ; Llamar a DOS [cite: 143, 146]

    mov dx, separador        ; Imprimir separador visual [cite: 153]
    int 21h                  ; [cite: 154]

    ; --- PASO 4: Salida de carácter e impresión de tabla ---
    ; 1. Imprimir cadena de etiqueta
    mov ah, 09h              ; [cite: 163]
    mov dx, etiqueta_a       ; [cite: 164]
    int 21h                  ; [cite: 165]

    ; 2. Imprimir el carácter en var_byte (Función 02h)
    mov al, [var_byte]       ; Cargar valor 42 [cite: 170]
    ; Nota: 42 es '*' en ASCII. Para ver 'Z' como pide la guía, 
    ; el documento suma 30h solo para demo[cite: 171, 178].
    add al, 30h              ; Convertir a ASCII demo [cite: 171]
    mov ah, 02h              ; Función DOS: imprimir carácter [cite: 174, 179]
    mov dl, al               ; Carácter a imprimir en DL [cite: 175]
    int 21h                  ; [cite: 176]

    ; 3. Nueva línea
    mov ah, 02h              ; [cite: 181]
    mov dl, CR               ; [cite: 183]
    int 21h                  ; [cite: 184]
    mov dl, LF               ; [cite: 186]
    int 21h                  ; [cite: 187]

    ; 4. Recorrer tabla e imprimir cada elemento [cite: 189]
    lea si, tabla_bytes      ; SI apunta al inicio de la tabla [cite: 190, 200]
    mov cx, ITERACIONES      ; CX = 5 iteraciones [cite: 192, 200]

imprimir_tabla:
    mov al, [si]             ; Obtener byte actual [cite: 194, 201]
    add al, 30h              ; Conversión simple a ASCII (para dígitos 0-9) [cite: 195, 202]
    
    mov ah, 02h              ; [cite: 199]
    mov dl, al               ; [cite: 208]
    int 21h                  ; [cite: 209]

    ; Imprimir espacio entre números
    mov dl, 20h              ; Código ASCII para espacio [cite: 212]
    int 21h                  ; [cite: 213]

    inc si                   ; Avanzar al siguiente byte [cite: 216, 218]
    loop imprimir_tabla      ; Decrementa CX y salta si CX != 0 [cite: 217, 219]

    ; --- Finalización ---
    mov dx, fin_msg          ; Mensaje de cierre [cite: 104]
    mov ah, 09h              ; [cite: 141]
    int 21h                  ; [cite: 143]

    mov ax, 4C00h            ; Función DOS: terminar con código 0 [cite: 155, 156]
    int 21h                  ; [cite: 155]