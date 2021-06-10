# Not Brain Nor Training
Autor: Yone Hernández León

### Descripción de la aplicación
Not Brain Nor Training es una aplicación de minijuegos que funcionan de manera similar al tan conocido título de Nintendo "Brain Training". Esta aplicación posee 3 minijuegos diferentes, y tiene la capacidad de guardar las puntuaciones de cada uno de los minijuegos para cada uno de los usuarios que jueguen.

### Caracteristicas de la aplicación
Not Brain Nor Training tiene las siguientes características:
- 3 Minijuegos diferentes: Sudoku, Memoria y Cambio de monedas
- Creación de usuarios
- Modificación de avatar de usuarios (utilizando cámara web)
- 5 filtros diferentes para avatares
- 5 paletas de color diferentes
- Modificación de volumen de música
- Modificación de volumen de sonido

### Decisiones adoptadas para la solución propuesta
Esta aplicación consta de diferentes archivos y directorios para la gestión de distintas funcionalidades. Dichos ficheros se describen brevemente a continuación:

#### TCCIU.pde
Este fichero es el fichero principal de la aplicación. Se encarga principalmente de mostrar y gestionar el menú principal, así como la pantalla de loggeo.

#### ManageUser.pde
Este archivo es el encargado de gestionar el guardado de los usuarios de la aplicación. Las funciones que posee son crear usuarios, modificar variables de estos usuarios (como los puntos de cada minijuego o el avatar) o eliminar usuarios.

#### User.pde
En este fichero se encuentra la clase User. Es la encargada de definir todos los parámetros de usuario que recibe la clase ManageUser para la gestión de usuarios.

#### MiniGame.pde
Aquí encontramos la clase abstracta MiniGame. Esta clase se encarga de definir las clases comunes que cada minijuego debe tener para funcionar correcta y compatiblemente con el muestreo de TCCIU.pde.

#### Sudoku.pde, Memory.pde, CoinChange.pde
Estos son los ficheros que contienen los tres minijuegos de la aplicación. Todos heredan de la clase MiniGame, e implementan sus propios métodos y atributos auxiliares para el correcto funcionamiento del juego.

#### data
Esta carpeta contiene el fichero users.json, donde encontramos todos los datos de cada usuario creado en la aplicación.

#### img
Aquí podemos encontrar todas las imagenes utilizadas en la aplicación. Algunas de estas imágenes son los avatares de los usuarios y el avatar por defecto, o las texturs utilizadas para las monedas y billetes del minijuego Cambio de Monedas

#### shaders
Este es el directorio que posee los distintos shaders de textura utilizados para la representación de las monedas del minijuego Cambio de Monedas.

#### Sudoku
En esta carpeta encontramos los ficheros Original.txt y Solved.txt, los cuales poseen los Sudokus de la aplicación, así como sus soluciones. 

### Resultado de la aplicación
![error](https://github.com/YoneHernandezLeon/TCCIU/blob/main/Media/gif.gif?raw=true)

### Referencias
##### Sonidos:
- Creados originalmente por Nicolás Almeida Ramírez
##### Lenguaje de programación:
- https://processing.org/reference/
##### Editor de imágenes:
- http://www.gimp.org.es
##### Generador de Sudokus
- https://qqwing.com/generate.html
##### Juego original
- https://www.nintendo.es/Juegos/Nintendo-Switch/Brain-Training-del-Dr-Kawashima-para-Nintendo-Switch-1656777.html
