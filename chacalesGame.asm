.data
    # Definir la cadena a imprimir
    hello_msg: .asciiz "Hello, World!\n"

.text
    # Cargar el código para imprimir cadena
    li $v0, 4          # Cargar el código 4 para imprimir cadena
    la $a0, hello_msg  # Cargar la dirección de la cadena en $a0
    syscall            # Llamar al sistema para imprimir la cadena

    # Terminar el programa
    li $v0, 10         # Cargar el código 10 para terminar el programa
    syscall            # Llamar al sistema para salir
