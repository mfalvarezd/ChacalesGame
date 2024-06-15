.data   

tablero:                    .space  48                                                                              #tablero que guardara la ubicacion de los chacales y los tesoros
descubiertas:               .space  48                                                                              #tablero que guardara la informacion sobre si la ubicacion de un tablero fue descubierto o no
tesorosDescubiertos:        .word   0                                                                               #contador para la cantidad de tesoros descubiertos
chacalesDescubiertos:       .word   0                                                                               # contados de chacales descubiertos
dineroGanado:               .word   0                                                                               #Dinero acumulado
titulo:                     .asciiz "Chacales Game\n"
    # Mensajes para imprimir
board_message:              .asciiz "Estado actual del tablero:\n"
money_message:              .asciiz "Dinero acumulado: $"
options_message:            .asciiz "\nOpciones disponibles:\n"
decision_message:           .asciiz "¿Qué desea hacer?\n1. Continuar jugando\n2. Retirarse\nIngrese su opción: "
exit_message:               .asciiz "\n¡Juego finalizado!\n"
treasures_found_message:    .asciiz "Número de tesoros encontrados: "
chacals_found_message:      .asciiz "Número de chacales encontrados: "
newline_message:            .asciiz "\n"





.text   


main:                       
