.data   

tablero:                    .space  12  # Espacio para el tablero de 12 casillas
descubiertas:               .space  12  # Espacio para el estado de las casillas (descubierto/no descubierto)
tesorosDescubiertos:        .word   0   # Contador para la cantidad de tesoros descubiertos
chacalesDescubiertos:       .word   0   # Contador de chacales descubiertos
dineroGanado:               .word   0   # Dinero acumulado
titulo:                     .asciiz "Chacales Game\n"
board_message:              .asciiz "Estado actual del tablero:\n"
money_message:              .asciiz "Dinero acumulado: $"
options_message:            .asciiz "\nOpciones disponibles:\n"
decision_message:           .asciiz "¿Qué desea hacer?\n1. Continuar jugando\n2. Retirarse\nIngrese su opción: "
exit_message:               .asciiz "\n¡Juego finalizado!\n"
treasures_found_message:    .asciiz "Número de tesoros encontrados: "
chacals_found_message:      .asciiz "Número de chacales encontrados: "
newline_message:            .asciiz "\n"
board_generation:           .asciiz "Generando tablero\n"

.text
.globl main

main:
    # Mostrar el título del juego
    li $v0, 4
    la $a0, titulo
    syscall
    
    # Mostrar mensaje de generación del tablero
    li $v0, 4
    la $a0, board_generation
    syscall
    
    # Inicializar el tablero
    jal inicializar_tablero
    
    # Bucle principal del juego
bucle_juego:
    jal mostrar_tablero
    # ... aquí iría el resto de la lógica del juego ...
    j bucle_juego

# Inicializar el tablero
inicializar_tablero:
    # Inicializar variables de conteo
    li $t0, 4  # Número de chacales
    li $t1, 8  # Número de tesoros
    li $t2, 12 # Número total de casillas
    
    # Limpiar el tablero
    la $t3, tablero
    la $t4, descubiertas
    li $t5, 0

clear_tablero:
    beq $t2, $zero, fin_clear
    sb $t5, 0($t3)
    sb $t5, 0($t4)
    addi $t3, $t3, 1
    addi $t4, $t4, 1
    subi $t2, $t2, 1
    j clear_tablero

fin_clear:
    # Inicializar número total de casillas de nuevo
    li $t2, 12
    la $t8, tablero  # Puntero para almacenar las posiciones usadas
    
   distribuir_chacales:
    beq $t0, $zero, distribuir_tesoros

generar_posicion_chacales:
    li $v0, 42       # Servicio para generar número aleatorio
    li $a1, 1        # Valor mínimo
    li $a2, 12       # Valor máximo
    syscall
    sub $v0, $v0, 1  # Ajustar el rango a 0-11
    la $t6, tablero
    add $t6, $t6, $v0

    # Verificar si la posición está vacía
    lb $t7, 0($t6)
    bne $t7, $zero, generar_posicion_chacales

    # Colocar chacal en la posición vacía
    li $t7, 1
    sb $t7, 0($t6)
    addi $t8, $t8, 1
    subi $t0, $t0, 1
    j distribuir_chacales

distribuir_tesoros:
    beq $t1, $zero, fin_inicializacion

generar_posicion_tesoros:
    li $v0, 42       # Servicio para generar número aleatorio
    li $a1, 1        # Valor mínimo
    li $a2, 12       # Valor máximo
    syscall
    sub $v0, $v0, 1  # Ajustar el rango a 0-11
    la $t6, tablero
    add $t6, $t6, $v0

    # Verificar si la posición está vacía
    lb $t7, 0($t6)
    bne $t7, $zero, generar_posicion_tesoros

    # Colocar tesoro en la posición vacía
    li $t7, 2
    sb $t7, 0($t6)
    addi $t8, $t8, 1
    subi $t1, $t1, 1
    j distribuir_tesoros
    
fin_inicializacion:
    jr $ra

# Mostrar el tablero
mostrar_tablero:
    # Mostrar mensaje de estado del tablero
    li $v0, 4
    la $a0, board_message
    syscall
    
    # Inicializar contadores
    la $t0, descubiertas
    li $t2, 12  # Número total de casillas
    
mostrar_loop:
    beq $t2, $zero, fin_mostrar
    lb $t3, 0($t0)
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, newline_message
    syscall
    addi $t0, $t0, 1
    subi $t2, $t2, 1
    j mostrar_loop

fin_mostrar:
    # Mostrar chacales encontrados
    li $v0, 4
    la $a0, chacals_found_message
    syscall
    lw $a0, chacalesDescubiertos
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline_message
    syscall
    
    # Mostrar tesoros encontrados
    li $v0, 4
    la $a0, treasures_found_message
    syscall
    lw $a0, tesorosDescubiertos
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline_message
    syscall
    
    jr $ra