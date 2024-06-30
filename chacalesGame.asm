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
decision_message:           .asciiz "¿Qué desea hacer?\n1. Continuar jugando\n0. Retirarse\nIngrese su opción: "
exit_message:               .asciiz "\n¡Juego finalizado!\n"
treasures_found_message:    .asciiz "Número de tesoros encontrados: "
chacals_found_message:      .asciiz "Número de chacales encontrados: "
newline_message:            .asciiz "\n"
board_generation:           .asciiz "Generando tablero\n"
message0:                   .asciiz "|0|"
message1:                   .asciiz "|1|"
newline:                    .asciiz "\n"
messageAleatorio:           .asciiz "Las posición aleatoria fue\n"
chacal:                     .asciiz "|Chacal|"
tesoro:                     .asciiz "|Tesoro|"
casillaNoEncontrada:        .asciiz "|x|"
winState:                   .word   0
foundAllTreasures:          .word   0
foundAllChacales:           .word   0
messageContinuar:           .asciiz "Presione Enter para continuar\n"
message:                    .asciiz "Ha empezado el juego\n"
intentosCasillaDescubierta: .word   3                                                                               #el contado de intentos de las veces que se puede repetir una posicion
msgCasillaEncontrada:       .asciiz "Casilla ya encontrada"
espacio:                    .space  4
.text   
                            .globl  main
                            .globl  print_array                                                                     # Declaración de la función print_array
                            .globl  generar_tablero
                            .globl  numero_aleatorio
                            .globl  print_tablero
                            .globl  print_proceso
                            .globl  wait_for_enter

main:                       

    li      $v0,                4
    la      $a0,                titulo
    syscall 
    li      $v0,                4                                                                                   # Código del servicio de imprimir string
    la      $a0,                message                                                                             # Dirección del mensaje
    syscall                                                                                                         # Llamar al sistema para imprimir el mensaje
    jal     wait_for_enter                                                                                          #espacio




    # Imprimir nueva línea para separación
    li      $v0,                4                                                                                   # Código del servicio de imprimir string
    la      $a0,                newline                                                                             # Dirección del mensaje de nueva línea
    syscall                                                                                                         # Llamar al sistema para imprimir la nueva línea

    # Mostrar mensaje de generación del tablero
    li      $v0,                4
    la      $a0,                board_generation
    syscall 
    jal     generar_tablero

    lw      $s1,                tesorosDescubiertos                                                                 #cargo una variable con la cantidad de tesoros Descubiertos
    lw      $s2,                winState                                                                            #estado de juego
    lw      $s3,                foundAllTreasures                                                                   #estado de si encontro todos los tesoros
    lw      $s4,                foundAllChacales                                                                    #estado de si encontro todos los chacales
    lw      $s5,                dineroGanado
    lw      $s6,                chacalesDescubiertos


whileNoWin:                 
    li      $v0,                4
    la      $a0,                board_message
    syscall 
    jal     print_tablero
    jal     print_proceso
    li      $v0,                4
    la      $a0,                messageAleatorio
    syscall 
    jal     numero_aleatorio
    li      $v0,                1                                                                                   #el numero aleatorio esta guardado en $a0
    syscall 
    move    $t0,                $a0

    jal     actualizar_tablero                                                                                      #esto solo es para probar que funciona pero deberias usar ese valor aleatorio para validar si lo que encontraste fue un chacal o tesoro
    ## tambien con ese mismo valor aleatorio falta revisar en el arreglo de descubiertos si ya fue descubierto antes o no si ya fue descubierto debes empezar la mecanica
    # de que no puede salir 3 veces seguidas una posicion que ya ha sido revelada, pero si sale otra posicion que no ha sido reveleada se vuelve a resetear en 3 el contador
    # si ya sale le sale 3 veces seguidas una posicion revelada automaticamente pierde el juego
    #debe perder cuando encuentre 4 chacales
    # y tiene opcion a retirarse a partir de 4 tesoros encontrados
    #falta el bucle del juego o sea que una vez que ya revelo una posicion o termino su turno vuelve a generarsele otro valor eleatorio etc es decir que vuelva a whileNoWin
    #espero me entiendasxdd sino me preguntas

    li      $v0,                4
    la      $a0,                newline
    syscall 
    jal     print_tablero





    li      $v0,                10                                                                                  # Llamar al sistema para salir
    syscall 

encontroChacal:             
    li      $v0,                4
    la      $a0,                chacal
    syscall 
encontroTesoro:             
    li      $v0,                4
    la      $a0,                tesoro
    syscall 
validarHallazgo:            
    la      $t1,                tablero                                                                             # Cargar la dirección base del arreglo 'tablero'
    sll     $t3,                $t3,                        2                                                       # Multiplicar el índice por 4 (tamaño de palabra)
    add     $t4,                $t3,                        $t1                                                     # Calcular la dirección del elemento del arreglo

    jr      $ra                                                                                                     # Retornar de la subrutina
actualizar_tablero:         
    # Verificar si la casilla ya ha sido descubierta
    la      $t1,                descubiertas                                                                        # Cargar la dirección base del arreglo 'descubiertas'
    sll     $t0,                $t0,                        2                                                       # Multiplicar el índice por 4 (tamaño de palabra)
    add     $t0,                $t0,                        $t1                                                     # Calcular la dirección del elemento del arreglo 'descubiertas'
    lw      $t2,                0($t0)                                                                              # Cargar el valor actual de la casilla descubiertas[$t0]

    bnez    $t2,                casillaYaEncontrada                                                                 # Saltar a casillaYaEncontrada si ya está descubierta

    # Si la casilla no ha sido descubierta, marcarla como descubierta
    li      $t2,                1                                                                                   # Valor que queremos almacenar en el arreglo (casilla descubierta)
    sw      $t2,                0($t0)                                                                              # Almacenar el valor 1 en la posición calculada del arreglo 'descubiertas'

    jr      $ra                                                                                                     # Retornar de la subrutina

casillaYaEncontrada:        
    li      $v0,                4
    la      $a0,                msgCasillaEncontrada
    syscall 

    jr      $ra                                                                                                     # Retornar de la subrutina
wait_for_enter:             
    la      $a0,                messageContinuar
    syscall 
    li      $v0,                8
    la      $a0,                espacio
    li      $a1,                2
    syscall 
    li      $v0,                4
    la      $a0,                newline
    syscall 
    jr      $ra                                                                                                     # Regresar de la subrutina
print_proceso:              
    # Mostrar mensaje de proceso
    li      $v0,                4
    la      $a0,                money_message
    syscall 
    li      $v0,                1
    move    $a0,                $s5
    syscall 
    li      $v0,                4
    la      $a0,                newline
    syscall 
    li      $v0,                4
    la      $a0,                treasures_found_message
    syscall 
    li      $v0,                1
    move    $a0,                $s1
    syscall 
    li      $v0,                4
    la      $a0,                newline
    syscall 
    li      $v0,                4
    la      $a0,                chacals_found_message
    syscall 
    li      $v0,                1
    move    $a0,                $s6
    syscall 
    li      $v0,                4
    la      $a0,                newline
    syscall 
    jr      $ra
numero_aleatorio:           
    li      $a1,                12
    li      $v0,                42

    syscall 
    jr      $ra
generar_tablero:            
    li      $t0,                4                                                                                   #numero de chacales
    addi    $sp,                $sp,                        -4                                                      #reservamos espacio
    sw      $ra,                0($sp)                                                                              # guardamos lo que habia en ra en la direccion de sp
loop:                       
    beq     $t0,                $zero,                      exitLoop
    jal     numero_aleatorio                                                                                        # genera un numero aleatorio y se guarda en a0
    move    $t1,                $a0

    sll     $t1,                $t1,                        2
    la      $t3,                tablero
    add     $t1,                $t1,                        $t3

    lw      $t2,                0($t1)

    beq     $t2,                $zero,                      continue
    sw      $zero,              0($t1)
    addi    $t0,                $t0,                        -1


continue:                   
    j       loop

exitLoop:                   

    lw      $ra,                0($sp)
    addi    $sp,                $sp,                        4

    jr      $ra

    # Función para imprimir el arreglo
print_array:                
    # Configuración inicial del arreglo
    la      $t0,                tablero                                                                             # Dirección base del arreglo
    li      $t2,                12                                                                                  # Tamaño del arreglo

print_loop:                 
    beqz    $t2,                end_print                                                                           # Si t2 es 0, termina la impresión del arreglo
    lw      $t5,                0($t0)                                                                              # Carga el valor en la posición actual del arreglo
    beq     $t5,                0,                          print0                                                  # Si el valor es 0, imprime "0"
    beq     $t5,                1,                          print1                                                  # Si el valor es 1, imprime "1"

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
    addi    $t0,                $t0,                        4                                                       # Avanza a la siguiente posición del arreglo
    addi    $t2,                $t2,                        -1                                                      # Decrementa el contador
    j       print_loop                                                                                              # Repite el ciclo de impresión del arreglo

end_print:                  
    # Imprime una nueva línea al final
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                newline                                                                             # Carga la dirección del mensaje de nueva línea
    syscall 

    jr      $ra
print_tablero:              
    # Configuración inicial del arreglo
    la      $t0,                descubiertas                                                                        # Dirección base del arreglo
    la      $t6,                tablero                                                                             # Direccion base del arreglo del tablero
    li      $t2,                12                                                                                  #tamano del arreglo

print_loopT:                
    beqz    $t2,                end_printT                                                                          # Si t2 es 0, termina la impresión del arreglo
    lw      $t5,                0($t0)                                                                              # Carga el valor en la posición actual del arreglo
    lw      $t7,                0($t6)                                                                              # Carga el valor en la posición actual del arreglo

    beq     $t5,                0,                          printCasillaNoEncontrada                                # Si el valor es 0, imprime "x"
    beq     $t5,                1,                          printCasillaEncontrada                                  # Si el valor es 1, imprime "Lo que sea que este dentro del arreglo"
printCasillaNoEncontrada:   
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                casillaNoEncontrada                                                                 # Carga la dirección del mensaje
    syscall 
    j       next_elementT
printCasillaEncontrada:     


    beq     $t7,                0,                          printChacal                                             # Si el valor es 0, imprime "Chacal"
    beq     $t7,                1,                          printTesoro                                             # Si el valor es 0, imprime "Tesoro"

printChacal:                
    li      $v0,                4
    la      $a0,                chacal
    syscall 
    j       next_elementT
printTesoro:                
    li      $v0,                4
    la      $a0,                tesoro
    syscall 
    j       next_elementT
next_elementT:              
    addi    $t0,                $t0,                        4                                                       # Avanza a la siguiente posición del arreglo
    addi    $t6,                $t6,                        4                                                       # Avanza a la siguiente posición del arreglo del tablero original
    addi    $t2,                $t2,                        -1                                                      # Decrementa el contador
    j       print_loopT                                                                                             # Repite el ciclo de impresión del arreglo

end_printT:                 
    # Imprime una nueva línea al final
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                newline                                                                             # Carga la dirección del mensaje de nueva línea
    syscall 

    jr      $ra                                                                                                     # Retorna a la llamada (a main en este caso)

