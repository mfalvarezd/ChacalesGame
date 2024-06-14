# Juego de Chacales en MIPS

Este proyecto implementa el juego de Chacales en lenguaje MIPS, un conjunto de instrucciones utilizado comúnmente en arquitecturas de computadoras educativas y embebidas.

![Screenshot](screenshot.png)

## Descripción

El juego de Chacales es un juego de tablero donde el jugador debe descubrir tesoros mientras evita a los chacales. El tablero consta de 12 casillas inicialmente ocultas, con 4 chacales y 8 tesoros distribuidos aleatoriamente al inicio de cada partida.

El objetivo del juego es recolectar 4 tesoros antes de descubrir todos los chacales o repetir el mismo número de casilla oculta 3 veces consecutivas.

## Funcionalidades

- **Tablero Dinámico:** Distribución aleatoria de chacales y tesoros al inicio de cada partida.
- **Interacción de Usuario:** Elección de casillas para descubrir su contenido.
- **Gestión de Estado:** Mostrar el estado del tablero, dinero ganado, tesoros encontrados y número de chacales descubiertos en cada turno.
- **Decisión Estratégica:** El jugador decide continuar jugando para aumentar su dinero o retirarse con la cantidad acumulada.

## Instalación

1. Clona el repositorio:
   git clone [https://github.com/mfalvarezd/ChacalesGame.git]
2. Ejecuta el código en un simulador MIPS compatible (por ejemplo, SPIM):
   spim -file juego_chacales.asm
## Uso

Inicia el juego según las instrucciones del simulador MIPS.
Selecciona una casilla para descubrir su contenido.
Sigue las indicaciones en pantalla para gestionar tu estrategia y decidir continuar o retirarte.
## Contribución
Si deseas contribuir a este proyecto, sigue estos pasos:

1. Haz un fork del repositorio.
2. Crea una nueva rama (git checkout -b feature/nueva-funcionalidad).
3. Realiza tus cambios y realiza commit (git commit -am 'Añade nueva funcionalidad').
4. Haz push a la rama (git push origin feature/nueva-funcionalidad).
5. Crea un nuevo Pull Request.


## Autores
Moises Alvarez(mfalvare@espol.edu.ec), Andres Zambrano(correo)

Enlace al proyecto: [https://github.com/mfalvarezd/ChacalesGame.git]
