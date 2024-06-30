.data   
tablero:                    .word   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1                                              # Espacio para el tablero de 12 casillas
descubiertas:               .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0                                              # Espacio para el estado de las casillas (descubierto/no descubierto)
tesorosDescubiertos:        .word   0                                                                               # Contador para la cantidad de tesoros descubiertos
chacalesDescubiertos:       .word   0                                                                               # Contador de chacales descubiertos
dineroGanado:               .word   0                                                                               # Dinero acumulado
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
message0:                   .asciiz "|0|"
message1:                   .asciiz "|1|"
newline:                    .asciiz "\n"

.text   
                            .globl  main
                            .globl  print_array                                                                     # Declaración de la función print_array
                            .globl  generar_tablero
                            .globl  numero_aleatorio

main:                       
    li      $v0,                4
    la      $a0,                titulo
    syscall 

    # Mostrar mensaje de generación del tablero
    li      $v0,                4
    la      $a0,                board_generation
    syscall 
    jal     generar_tablero
    jal     print_array
    li      $v0,                10                                                                                  # Llamar al sistema para salir
    syscall 

numero_aleatorio:           
    li      $a1,                13
    li      $v0,                42
    syscall 
    jr      $ra
generar_tablero:            
    li      $t0,                4                                                                                   #numero de chacales
    addi    $sp,                $sp,                -4                                                              #reservamos espacio
    sw      $ra,                0($sp)                                                                              # guardamos lo que habia en ra en la direccion de sp
loop:                       
    beq     $t0,                $zero,              exitLoop
    jal     numero_aleatorio                                                                                        # genera un numero aleatorio y se guarda en a0
    move    $t1,                $a0

    sll     $t1,                $t1,                2
    la      $t3,                tablero
    add     $t1,                $t1,                $t3

    lw      $t2,                0($t1)

    beq     $t2,                $zero,              continue
    sw      $zero,              0($t1)
    addi    $t0,                $t0,                -1


continue:                   
    j       loop

exitLoop:                   

    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4

    jr      $ra

    # Función para imprimir el arreglo
print_array:                
    # Configuración inicial del arreglo
    la      $t0,                tablero                                                                             # Dirección base del arreglo
    li      $t2,                12                                                                                  # Tamaño del arreglo

print_loop:                 
    beqz    $t2,                end_print                                                                           # Si t2 es 0, termina la impresión del arreglo
    lw      $t5,                0($t0)                                                                              # Carga el valor en la posición actual del arreglo
    beq     $t5,                0,                  print0                                                          # Si el valor es 0, imprime "0"
    beq     $t5,                1,                  print1                                                          # Si el valor es 1, imprime "1"

print0:                     
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                message0                                                                            # Carga la dirección del mensaje "0 "
    syscall 
    j       next_element

print1:                     
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                message1                                                                            # Carga la dirección del mensaje "1 "
    syscall 
    j       next_element

next_element:               
    addi    $t0,                $t0,                4                                                               # Avanza a la siguiente posición del arreglo
    addi    $t2,                $t2,                -1                                                              # Decrementa el contador
    j       print_loop                                                                                              # Repite el ciclo de impresión del arreglo

end_print:                  
    # Imprime una nueva línea al final
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                newline                                                                             # Carga la dirección del mensaje de nueva línea
    syscall 

    jr      $ra                                                                                                     # Retorna a la llamada (a main en este caso)

