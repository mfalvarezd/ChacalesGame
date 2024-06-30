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
decision_message:           .asciiz "Qué desea hacer?\n1. Continuar jugando\n0. Retirarse\nIngrese su opción: "
exit_message:               .asciiz "\n Juego finalizado!\n Te llevas tu proceso!\n"
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
messageContinuar:           .asciiz "Presione Enter para continuar\n"
message:                    .asciiz "Ha empezado el juego\n"
intentosCasillaDescubierta: .word   3                                                                               #el contado de intentos de las veces que se puede repetir una posicion
msgCasillaEncontrada:       .asciiz "Casilla ya encontrada"
espacio:                    .space  4
intentosPorCasilla:         .word   3
msgIntentos:                .asciiz "Intentos disponibles: "
msgPerdioIntentos:          .asciiz "Game Over: Te has quedado sin intentos, haz perdido todo"
msgGanaTesoros:             .asciiz "Ha encontrado almenos 4 tesoros puede retirase si lo desea o seguir jugando\n"
invalid_input:              .asciiz "Valor no ha valido\n"
msgChacalesf:               .asciiz "Haz encontrado todos los chacales!\n"
.text   
                            .globl  main
                            .globl  generar_tablero
                            .globl  numero_aleatorio
                            .globl  print_tablero
                            .globl  print_proceso
                            .globl  wait_for_enter

main:                       

    li      $v0,                4
    la      $a0,                titulo
    syscall 
    li      $v0,                4                                                                                   # C�digo del servicio de imprimir string
    la      $a0,                message                                                                             # Direcci�n del mensaje
    syscall                                                                                                         # Llamar al sistema para imprimir el mensaje
    jal     wait_for_enter                                                                                          #espacio




    # Imprimir nueva l�nea para separaci�n
    li      $v0,                4                                                                                   # C�digo del servicio de imprimir string
    la      $a0,                newline                                                                             # Direcci�n del mensaje de nueva l�nea
    syscall                                                                                                         # Llamar al sistema para imprimir la nueva l�nea

    # Mostrar mensaje de generaci�n del tablero
    li      $v0,                4
    la      $a0,                board_generation
    syscall 
    jal     generar_tablero

    lw      $s1,                tesorosDescubiertos                                                                 #cargo una variable con la cantidad de tesoros Descubiertos
    lw      $s2,                winState                                                                            #estado de juego                                                                    #estado de si encontro todos los chacales
    lw      $s5,                dineroGanado
    lw      $s6,                chacalesDescubiertos
    lw      $s7,                intentosPorCasilla
    # Inicializaci�n de variables fuera del bucle


whileNoWin:                 
    li      $t1,                4
    li      $t6,                4
    slt     $t2,                $s1,                        $t1
    beq     $s7,                $zero,                      sinIntentos
    beq     $s6,                $t1,                        foundAllchacales
    beq     $t2,                $zero,                      ganaJuego
seguir:                     
    li      $v0,                4
    la      $a0,                board_message
    syscall 
    jal     print_tablero
    jal     print_proceso

    jal     wait_for_enter

    li      $v0,                4
    la      $a0,                newline
    syscall 
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
    j       whileNoWin
ganaJuego:                  

    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                msgGanaTesoros                                                                      # Direcci�n del mensaje de pregunta
    syscall 
    la      $a0,                decision_message
    syscall 

    # Leer entrada del usuario
    li      $v0,                5                                                                                   # Servicio para leer un entero
    syscall 
    move    $t0,                $v0                                                                                 # Almacenar el valor le�do en $t0

    # Validar la entrada del usuario (debe ser 0 o 1)
    beq     $t0,                0,                          user_quit                                               # Si $t0 es 0, el usuario quiere retirarse
    beq     $t0,                1,                          user_continue                                           # Si $t0 es 1, el usuario quiere continuar
    nop                                                                                                             # No operation (recomendado despu�s de un branch delay slot)
    # Mensaje de error si la entrada no es v�lida (opcional)
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                invalid_input                                                                       # Direcci�n del mensaje de error
    syscall 

user_continue:              
    # Aqu� puedes realizar las acciones necesarias si el usuario decide continuar
    # Puedes almacenar la decisi�n del usuario en una variable si es necesario

    j       continue_game                                                                                           # Saltar a la parte del c�digo donde se maneja la continuaci�n del juego

    # Etiqueta si el usuario quiere retirarse (0)
user_quit:                  
    # Aqu� puedes realizar las acciones necesarias si el usuario decide retirarse
    # Puedes almacenar la decisi�n del usuario en una variable si es necesario
    li      $v0,                4
    la      $a0,                newline
    syscall 
    li      $v0,                4
    la      $a0,                exit_message
    syscall 
    jal     print_proceso
    j       quit_game                                                                                               # Saltar a la parte del c�digo donde se maneja el retiro del juego

    # Etiqueta para continuar el juego
continue_game:              
    # Aqu� puedes continuar con la l�gica del juego despu�s de que el usuario decide continuar
    j       seguir                                                                                                  # Saltar al final de la secci�n de continuar juego


foundAllchacales:           
    li      $v0,                4
    la      $a0,                newline
    syscall 
    li      $v0,                4
    la      $a0,                msgChacalesf
    syscall 
    j       sinIntentos
sinIntentos:                

    la      $a0,                msgPerdioIntentos
    syscall 
quit_game:                  
    li      $v0,                10                                                                                  # Llamar al sistema para salir
    syscall 

encontroChacal:             
    li      $v0,                4
    la      $a0,                chacal
    syscall 
    add     $s6,                $s6,                        1                                                       #contador de chacales
    j       exit
encontroTesoro:             
    li      $v0,                4
    la      $a0,                tesoro
    syscall 
    add     $s1,                $s1,                        1                                                       #contador de Tesoros
    addi    $s5,                $s5,                        100                                                     #dineroGanado
    j       exit

validarHallazgo:            
    la      $t1,                tablero                                                                             # Cargar la direcci�n base del arreglo 'tablero'
    sll     $t3,                $t3,                        2                                                       # Multiplicar el �ndice por 4 (tama�o de palabra)
    add     $t4,                $t3,                        $t1                                                     # Calcular la direcci�n del elemento del arreglo

    # Retornar de la subrutina
actualizar_tablero:         
    # Verificar si la casilla ya ha sido descubierta
    la      $t3,                tablero
    la      $t1,                descubiertas                                                                        # Cargar la direcci�n base del arreglo 'descubiertas'

    sll     $t0,                $t0,                        2                                                       # Multiplicar el �ndice por 4 (tama�o de palabra)
    add     $t4,                $t0,                        $t3
    add     $t0,                $t0,                        $t1                                                     # Calcular la direcci�n del elemento del arreglo 'descubiertas'
    lw      $t5,                0($t4)
    lw      $t2,                0($t0)                                                                              # Cargar el valor actual de la casilla descubiertas[$t0]
    bnez    $t2,                casillaYaEncontrada                                                                 # Saltar a casillaYaEncontrada si ya est� descubierta
    beq     $t5,                $zero,                      encontroChacal
    j       encontroTesoro
exit:                       
    # Si la casilla no ha sido descubierta, marcarla como descubierta
    li      $t2,                1                                                                                   # Valor que queremos almacenar en el arreglo (casilla descubierta)
    sw      $t2,                0($t0)                                                                              # Almacenar el valor 1 en la posici�n calculada del arreglo 'descubiertas'
    li      $s7,                3
    jr      $ra                                                                                                     # Retornar de la subrutina

casillaYaEncontrada:        
    li      $v0,                4
    la      $a0,                msgCasillaEncontrada
    syscall 
    addi    $s7,                $s7,                        -1

    jr      $ra                                                                                                     # Retornar de la subrutina
wait_for_enter:             
    li      $v0,                4
    la      $a0,                newline
    syscall 
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
    # Mostrar mensaje de dinero
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                money_message                                                                       # Direcci�n del mensaje de dinero
    syscall 

    li      $v0,                1                                                                                   # Servicio para imprimir entero
    move    $a0,                $s5                                                                                 # Valor de dinero en $s5
    syscall 

    # Mostrar mensaje de tesoro encontrado
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                newline                                                                             # Nueva l�nea entre mensajes
    syscall 

    li      $v0,                4                                                                                   # Servicio para imprimir entero
    la      $a0,                treasures_found_message                                                             # Direcci�n del mensaje de tesoros encontrados
    syscall 

    li      $v0,                1                                                                                   # Servicio para imprimir entero
    move    $a0,                $s1                                                                                 # Valor de tesoros encontrados en $s1
    syscall 

    # Mostrar mensaje de chacal encontrado
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                newline                                                                             # Nueva l�nea entre mensajes
    syscall 

    li      $v0,                4                                                                                   # Servicio para imprimir entero
    la      $a0,                chacals_found_message                                                               # Direcci�n del mensaje de chacales encontrados
    syscall 

    li      $v0,                1                                                                                   # Servicio para imprimir entero
    move    $a0,                $s6                                                                                 # Valor de chacales encontrados en $s6
    syscall 
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                newline                                                                             # Nueva l�nea entre mensajes
    syscall 
    li      $v0,                4                                                                                   # Servicio para imprimir entero
    la      $a0,                msgIntentos
    syscall 

    li      $v0,                1                                                                                   # Servicio para imprimir entero
    move    $a0,                $s7
    syscall 

    # Finalizar funci�n
    jr      $ra                                                                                                     # Retornar
numero_aleatorio:           
    li      $a1,                12
    li      $v0,                42                                                                                  # Cargar el c�digo del servicio para generar un n�mero aleatorio
    syscall                                                                                                         # Llamar al sistema para generar un n�mero aleatorio

    # Manejo b�sico de errores: verificar si syscall fue exitosa (no se incluyen verificaciones detalladas de errores por simplicidad)
    bnez    $v0,                syscall_success                                                                     # Saltar si la llamada al sistema fue exitosa
    nop                                                                                                             # No operation (recomendado despu�s de un branch delay slot)

    # Manejar error si syscall no fue exitosa
    li      $v0,                10                                                                                  # Cargar el c�digo del servicio para salir del programa
    syscall                                                                                                         # Llamar al sistema para salir del programa

syscall_success:            
    move    $v0,                $a0                                                                                 # Mover el resultado del n�mero aleatorio de $a0 a $v0
    jr      $ra                                                                                                     # Retornar de la funci�n
generar_tablero:            
    li      $t0,                4                                                                                   # N�mero de chacales
    addi    $sp,                $sp,                        -4                                                      # Reservar espacio en la pila
    sw      $ra,                0($sp)                                                                              # Guardar $ra en la pila

loop:                       
    beq     $t0,                $zero,                      exitLoop                                                # Salir del bucle si $t0 (n�mero de chacales) es 0
    jal     numero_aleatorio                                                                                        # Generar un n�mero aleatorio
    sll     $t1,                $v0,                        2                                                       # Multiplicar el n�mero aleatorio por 4 (tama�o de palabra en bytes)
    la      $t2,                tablero                                                                             # Cargar la direcci�n base del arreglo tablero
    add     $t1,                $t1,                        $t2                                                     # Calcular la direcci�n de la posici�n aleatoria en el tablero

    lw      $t3,                0($t1)                                                                              # Cargar el valor en la posici�n aleatoria del tablero

    beq     $t3,                $zero,                      continue                                                # Continuar si la posici�n est� vac�a (valor 0)
    sw      $zero,              0($t1)                                                                              # Marcar la posici�n como ocupada (valor 0)
    addi    $t0,                $t0,                        -1                                                      # Decrementar el contador de chacales

continue:                   
    j       loop                                                                                                    # Volver al inicio del bucle

exitLoop:                   
    lw      $ra,                0($sp)                                                                              # Restaurar $ra desde la pila
    addi    $sp,                $sp,                        4                                                       # Liberar espacio en la pila
    jr      $ra                                                                                                     # Retornar


print_tablero:              
    # Guarda los registros que se usar�n y configura los arreglos
    addi    $sp,                $sp,                        -8                                                      # Reserva espacio en la pila
    sw      $ra,                4($sp)                                                                              # Guarda la direcci�n de retorno
    sw      $t0,                0($sp)                                                                              # Guarda $t0 en la pila si es necesario
    # Configuraci�n inicial del arreglo
    la      $t0,                descubiertas                                                                        # Direcci�n base del arreglo
    la      $t6,                tablero                                                                             # Direccion base del arreglo del tablero
    li      $t2,                12                                                                                  #tamano del arreglo

print_loopT:                
    beqz    $t2,                end_printT                                                                          # Si t2 es 0, termina la impresi�n del arreglo
    lw      $t5,                0($t0)                                                                              # Carga el valor en la posici�n actual del arreglo
    lw      $t7,                0($t6)                                                                              # Carga el valor en la posici�n actual del arreglo

    beq     $t5,                0,                          printCasillaNoEncontrada                                # Si el valor es 0, imprime "x"
    beq     $t5,                1,                          printCasillaEncontrada                                  # Si el valor es 1, imprime "Lo que sea que este dentro del arreglo"
printCasillaNoEncontrada:   
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                casillaNoEncontrada                                                                 # Carga la direcci�n del mensaje
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
    addi    $t0,                $t0,                        4                                                       # Avanza a la siguiente posici�n del arreglo
    addi    $t6,                $t6,                        4                                                       # Avanza a la siguiente posici�n del arreglo del tablero original
    addi    $t2,                $t2,                        -1                                                      # Decrementa el contador
    j       print_loopT                                                                                             # Repite el ciclo de impresi�n del arreglo

end_printT:                 
    # Imprime una nueva l�nea al final
    li      $v0,                4                                                                                   # Servicio para imprimir string
    la      $a0,                newline                                                                             # Carga la direcci�n del mensaje de nueva l�nea
    syscall 

    lw      $ra,                4($sp)                                                                              # Restaura $ra desde la pila
    lw      $t0,                0($sp)                                                                              # Restaura $t0 si fue modificado
    addi    $sp,                $sp,                        8                                                       # Libera espacio en la pila
    jr      $ra                                                                                                     # Retorna                                                                                                     # Retorna a la llamada (a main en este caso)
