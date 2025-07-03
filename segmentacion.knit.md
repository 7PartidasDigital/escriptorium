---
title: "Segmentacion"
author:
- "José Manuel Fradejas Rueda"
- "Filología Digital UVa"
date: "2025-07-03"
output: html_document
---

<div>
<center>
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/UVa_eS_logo.png?raw=true" width="350"/>
</center>
</div>

# Manual de eScriptorium
## Segmentación

La segmentación es es proceso básico para poder llevar a cabo la transcripción de cualquier texto que tengamos en una imagen. En esta fase se le pide que localice la regiones de texto que hay dentro de la imagen y las líneas que lo constituye. Para ello, `eS` emplea un modelo de segmentación que se ha entrenado previamente con un conjunto de datos. Este modelo es capaz de detectar las regiones de texto y las líneas de forma automática. Pero no es el único que puedes usar. Puedes crear tu propio modelo de segmentación o usar uno ya existente. Para ello, haz clic en el botón `Models` que hay en la barra negra superior.

Se abrirá una nueva página donde podrás ver los modelos de segmentación que tienes disponibles. Son los que los usuarios del grupo de `Filología Digital` de la Universidad hemos creado (INCUANBLES_HSMS_v3_1.2_best) u otros que hemos localizado en la red y que son públicos como CatMus_Medieval-160. Los que hay disponibles ahora mismo son suficientes para este manual.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_025.png?raw=true" alt="Modelos disponibles por defecto" width="85%" />
<p class="caption">Modelos disponibles por defecto</p>
</div>

Si te fijas en la segunda columna, verás que en unos casos dice `Recognize` y en otros `Segment`. Esto es porque algunos modelos están preparados para reconocer el texto y otros solo para segmentarlo. La columna `Script` te indica el tipo de alfabeto para el que se ha desarrollado el modelo, por lo general, es `Latin`. En la columna `Size` puedes ver el tamaño del modelo en MB. La columna `Accuracy` te indica la precisión del modelo. Cuanto más alta sea, mejor será el modelo. La columna `Right` indica si el modelo es público o privado. Por ahora solo verás modelos públicos, que son los que ofrecemos desde la Universidad de Valladolid. Los privados son aquellos que has subido tú con el botón `Upload a model` que hay en la parte superior derecha. Si haces clic en el icono de descarga (verde con una hoja y una flecha que apunta hacia abajo), podrás descargar el modelo a tu ordenador.

Haz clic en `My Projects`. Como en el capítulo anterior creaste el proyecto `Primer documento` haz clic sobre él. Habrá cambiado el aspecto de la página. 

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_026.png?raw=true" alt="Contenido del proyecto `Primer documento`" width="85%" />
<p class="caption">Contenido del proyecto `Primer documento`</p>
</div>

Te muestra todos los documentos que constituyen el proyecto `Primer documento`. Solo puede haber uno (salvo y has estado enredando 😉 en el proyecto). Te muestra una mininatura del documento, el nombre del documento, quién lo ha subido (en grupos de trabajo puede haber varios propietarios), la fecha de la última modificación, el número de imágenes que tiene y tres iconos. Uno azul para las etiquetas que le quieras añadir (por el momentos no es útil), y otros dos bajo el marbete `Actions`. El primero es para editar el documento, el segundo para eliminarlo (¡Cuidado con este!). Si situas el ratón sobre el nombre o sobre la miniatura y haces clic, se abrirá el documento.

Habrás vuelto a una pantalla que ya conoces del capítulo anterior, en el que subiste el documento. Es hora de segmentarlo. Para ello, haz clic en el botón `Select all` que hay en la parte superior izquierda.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_027.png?raw=true" alt="Todas las imágenes seleccionadas" width="85%" />
<p class="caption">Todas las imágenes seleccionadas</p>
</div>

Todas las miniaturas cambiarán el marco y será negro y que La la derecha los botones `Select all` y `Unselect all` dice `Selected 4/4`. Ahora haz clic en el botón azul que dice `Segment`. Se encuentra debajo de la caja de carga de las imágenes, en la parte derecha. Al hacer clic, se abrirá el diálogo para seleccionar el modelo.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_022.png?raw=true" alt="Diálogo de segmentación" width="40%" />
<p class="caption">Diálogo de segmentación</p>
</div>

Por defecto ofrece el modelo `default (blla.model)`. Si abres el desplegable, verás que te hay varios modelos, que coinciden con los que viste al pulsar en la pestaña `My models`. Son `baselines` y `lineas_v6` que solo trazarían las líneas en las que vea texto. `regions` y `areas_v2` buscarían las zonas (regiones) del texto. Por el momento, vas a quedarte con el que ofrece como `default`, que lo encontrarás en cualquier instancia de *eScriptorium*. Y funciona realmente bien, aunque siempre hay sus más y sus menos.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_028.png?raw=true" alt="Diálogo de segmentación" width="40%" />
<p class="caption">Diálogo de segmentación</p>
</div>

Los otros dos deplegables permiten decidir si quieres que el modelo detecte las líneas de texto o las regiones de texto. En este caso, vamos a dejarlo como está: que localice regiones y líneas automáticamente.

El tercer desplegable es para indicarle en qué dirección va el texto. En este caso, como es un texto con alfabeto latino y que está escrito de izquierda a derecha y que se ha de leer de arriba abajo, lo dejarás como está.

Por último hay una casilla que está marcada por defecto que dice `Override`. Esto significa que las imágenes o algunas de ellas ya están segmentadas, las volvería a segmentar y borraría todo lo anterior (transcripciones incluidas). Si no la marcas, solo segmentará las imágenes que no estén segmentadas. En este caso, como es la primera vez que lo haces, lo dejaremos marcado. Pero en el futuro ten cuidado, pues borraría todo lo que tuvieras hecho.

Haz clic en el botón `Segment` que hay en la parte inferior derecha. Desaparecerá el diálogo y verás que en los miniaturas ha aparecido una banda amarillenta que parpadea con un signo de prohibido. Esto es porque el modelo está trabajando. Puede servir para detener el proceso si ves que no está funcionando como esperabas. Pero no lo hagas, porque lo que has hecho es correcto y el modelo está trabajando.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_029.png?raw=true" alt="Indicación de que está trabajando" width="20%" />
<p class="caption">Indicación de que está trabajando</p>
</div>

Esto puede tardar un poco, depende del número de imágenes y del tamaño de las mismas. Pasado un rato (variable), verás que las miniaturas han cambiado. Ahora tienen en la parte inferior izquierda cuatro rayitas verdes que indican que el modelo ha segmentado la imagen. Y en la parte superior habrá aparecido un cartel de color verde que indicará que ha concluido la segmentación. Deberá decir `Segmentation done! (n)` en donde `n` indica el número de imágenes y debe ser el mismo que el de imágenes seleccionadas. En nuestro caso `4`.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_030.png?raw=true" alt="Segmentación finalizada" width="85%" />
<p class="caption">Segmentación finalizada</p>
</div>

Si haces clic en una de las miniaturas, se abrirá la imagen y podrás ver cómo ha segmentado el texto. Si lo haces con la pestaña `Edit` abrirá la primera. Haz clic en `Edit`.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_031.png?raw=true" alt="El editor de eScriptorium" width="85%" />
<p class="caption">El editor de eScriptorium</p>
</div>

El resultado parace satisfactorio. Ha marcado correctamente la caja y las líneas y ha ignorado el recuadro de la inicial decorada. Es un dibujo de donde no puede extraer texto, aunque en su interior haya una `D`.

Sin embargo, no todo lo que ha marcado interesa. Verás que en la parte superior hay dos líneas que marcan texto manuscrito. Puede que te interese, aunque lo más probable es que no. este es un pequeño problema que hay que solucionar.

Si te fijas, al final de la página hay una `a` que no ha tenido en cuenta. Se trata de la signatura tipográfica del impreso. Quizá te interese, o quizá no. A mí me interesa porque ya que es información que a otros les puede venir bien. hay que marcarlo manualmente, como el borrar las líneas que hay en la parte suprior de la página.

Antes de hacerlo, recórrete todas las páginas. Para ello usa el signo `＞` que hay en la parte superior derecha. Si haces clic, irás a la siguiente página. Si mantienes pulsado, irás avanzando rápidamente por todas las páginas del documento. Recorre todas las páginas y comprueba que el modelo ha segmentado correctamente el texto. Para retroceder usa el signo `＜` que hay a la izquierda del anterior. Si mantienes pulsado, irás retrocediendo rápidamente por todas las páginas del documento.

Verás que todas las páginas tienen algún problemilla debido a las notas manuscritas de unos lectores y no interesan. *eScriptorium* tiene herramientas para solucionarlo. Vamos a ello.

## Herramientas de edición

En la parte superior verás que hay una barra (debajo de la franja negra) con varios botones. El primero, una flecha que apunta hacia la izquierda, es para volver a la página de `My Projects`.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_032.png?raw=true" alt="Menú principal del editor" width="85%" />
<p class="caption">Menú principal del editor</p>
</div>

La imagen anterior muestra el menún principal dentro del editor de *eScriptorium*. Algunos elementos los encontraras en varias partes de la interfaz. Por ejemplo, el botón `Description`, `Ontology`, `Images`, `Edit` y `Reports` los tienes también cuando tienes activo cualquier documento. El bloque dela derecha es el más importante en esta barra principal, pues solo aparecen cuando estás dentro del editor. Vamos a ir de izquierda a derecha.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_033.png?raw=true" alt="Bloque principal del editor" width="50%" />
<p class="caption">Bloque principal del editor</p>
</div>

Lo que tienes que estar viendo es la imagen de la página que estás editando y verás que hay dos botones en azul, mientras que los otros tres están en gris. 

De los dos azules, uno tiene unas rayitas horizontales. Este permite _encender_ y _apagar_ la imagen con el texto segmentado. Si lo pulsas, verás que desaparece la imagen con las líneas y las regiones segmentadas. Si lo vuelves a pulsar, volverá a aparecer.

El siguiente botón en azul, que representa una letra `A` y un signo japonés o chino, permite encender y apagar el texto segmentado. Si lo pulsas, verás que desaparece el texto segmentado y solo queda la imagen original con la segmentación. Si lo vuelves a pulsar, volverá a aparecer el texto segmentado.


Vamos ahora con los botones grises. El botón `Metadatos` (he puesto el nombre en azul claro en la imagen) permite editar los metadatos de cada una de las imágenes. Por el momento no lo vamos a usar, pero es interesante que sepas que existe. Si quieres pulsalo y verás que sale un cuadro de diálogo a la derecha de la imagen segmentada. Déjalo como estaba, en gris.

El botón que tiene un ojo, pero que ahora está en gris, permite ver la imagen sin las marcas de regiones y líneas. Si lo pulsas, verás que aparece en el lado izquierdo la imagen original.

El último, a la derecha del todo, tiene tres líneas numeradas. Este botón permite acceder al texto transcrito. Ahora no podrás ver nada, por que se ha transcrito todavía. Pero fíjate que tiene los números de las líneas que ha segmentado el modelo.

Si activas todos estos botones (salvo de de metadatos), verás que la imagen se queda como en la siguiente imagen:

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_034.png?raw=true" alt="Todas las ventanas del editor activadas" width="50%" />
<p class="caption">Todas las ventanas del editor activadas</p>
</div>

Si te fijas, encima de cada una de las ventanas que se han abierto al pulsar los botones, tienen en la parte superior el mismo icono que el botón correspondiente (el ojo, las rayitas, la `A` y signo japonés, y las líneas numeradas) y, a su derecha una serie de botones que permiten acceder a cada una de las posibles funciones de cada una de las ventanas.

## Editar la imagen

Desactiva todas las ventanas salvo la del ojo. Se quedrá solo la imagen sin las marcas. Posiblemente no la veas toda ya que ocupará todo el espacio disponible. Mira en el margen izquierdo, a la izquerda del ojo. Verás tres botones con una lupa. Uno sin nada dentro, otro con un signo de `+` y otro con un signo de `-`. Estos botones permiten acercar o alejar la imagen. Si pulsas el de `+`, verás que la imagen se acerca. Si pulsas el de `-`, se aleja. El del centro, sin nada, permite volver al tamaño original.

Por cierto, lo que hacen las lupas con el `+` y el `-`, también lo puedes hacer con la rueda del ratón. Si la giras hacia adelante, disminuirá la imagen. Si la giras hacia atrás, la ampliarás.

Si pulsas el botón secundario encima de la imagen, la puedes mover dentro de la ventana.

Estas funciones también están disponibles en la ventana de las rayitas, que es la que vamos a usar para editar el texto segmentado. Si pulsas el botón secundario encima de las rayitas, podrás mover la imagen dentro de la ventana.

Verás que encima de la imagen hay otros tres botones. El primero, con una flecha hacia abajo, permite descargar la imagen (o abrirla en otra pestaña del navegador). Los otros dos permiten rotar de 90º en 90º las imágenes. Bien contra el snetido del reloj (el de la izquierda) bien a favor del reloj (el de la derecha). No es mucho lo que hace, pero puede ser útil si la imagen está girada. Descativa la imagen y vuelve a activar la ventana de las rayitas.


## Editar la segmentación

Con el botón central reduce la imagen para que la veas entera en el navegador. Verás que hay una serie de botones.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_035.png?raw=true" alt="Botones del menú de segmentación" width="50%" />
<p class="caption">Botones del menú de segmentación</p>
</div>

El primero, el de la flecha hacia la izquierda, es dehacer algo que se acaba de hacer. Es lo mismo que control (cmd) `Z`. El segundo, el de la flecha hacia la derecha, es rehacer algo que se ha deshecho. Es lo mismo que control (cmd) `Y`.

El tercero, tiene unos engranajes, permite acceder al editor de segmentación, aunque no tengo muy claro para que sirve. La información es nula.

El cuarto, el del círculo divido en dos, permite convertir la imagen a dos colores (binarizar). No lo he usado nunca.

Los importantes son los siguientes, y son los que permite editar la segmentación.

## Editar las regiones

El editor de regiones se activa con el botón que tiene cuatro cadraditos dentro. Si lo pulsas, verás que se coloren las regiones que detectó la segmentación. También lo puedes activar pulando la `R` del teclado. Si lo pulsas de nuevo, se desactivará.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_036.png?raw=true" alt="Edición de región activado" width="50%" />
<p class="caption">Edición de región activado</p>
</div>

Una vez activada la edición de regiones, si haces clic dentro de cualquiera de ellas, verás que se encienden unos puntos blancos y, además, en el margen izquierdo aparecerá dos nuevos botones. Uno con una `T` y una flecha de dos puntas a su lado y otro una papelera con fondo rojo.

Activa las regiones, y haz clic en la pequeña región que hay en la parte superior, pues la vas a borrar. Al hacer clic sobre esa zona, el perímetro de la región se llenará de cuadraditos blancos. Son los puntos que delimitan la región.

<div class="figure" style="text-align: center">
<img src="https://github.com/7PartidasDigital/escriptorium/blob/main/imagenes/eS_UVa_037.png?raw=true" alt="Edición de región activado" width="50%" />
<p class="caption">Edición de región activado</p>
</div>

