/*
M�DULO 4.- CURSORES
Los cursores son objetos que permiten recorrer fila a fila una tabla o vista 
de forma individual.

Los cursores son �tiles cuando se necesita procesar datos de una tabla de 
forma individual o cuando se necesita hacer c�lculos complejos en funci�n 
de los datos de cada fila.

Un cursor se define en una consulta SQL y se utiliza para recorrer las filas
de una tabla una por una. A medida que el cursor avanza por las filas, se 
pueden realizar operaciones en cada fila, como actualizar, eliminar o insertar datos.

Los cursores se utilizan en SQL Server principalmente en programaci�n de 
procedimientos almacenados y funciones para procesar datos en tiempo real 
y realizar operaciones complejas en los datos.

Sin embargo, su uso debe ser cuidadoso, ya que pueden afectar negativamente el 
rendimiento de la base de datos si se utilizan de manera inadecuada.

Ventajas de usar cursores
Aunque los cursores tienen algunas desventajas, tambi�n tienen algunas ventajas 
que pueden hacer que sean �tiles en ciertos casos, como:

Permiten procesamiento iterativo: Los cursores permiten procesar los resultados 
de una consulta en una base de datos de forma iterativa, lo que puede ser �til 
en situaciones en las que se requiere un procesamiento complejo o personalizado 
de los datos.
Facilitan la manipulaci�n de datos: Los cursores pueden facilitar la manipulaci�n 
de datos en situaciones en las que se requiere el procesamiento de grandes vol�menes 
de informaci�n de forma detallada o secuencial.
Permiten procesamiento basado en condiciones: Los cursores permiten procesar los 
resultados de una consulta en una base de datos en funci�n de condiciones espec�ficas,
lo que puede ser �til en situaciones en las que se necesita realizar un procesamiento 
condicional de los datos.
Permiten el control del flujo del programa: Los cursores permiten un mayor control 
del flujo del programa al permitir iterar a trav�s de los resultados de una consulta 
de forma personalizada y flexible.

Desventajas de usar cursores
Los cursores en programaci�n son una herramienta que permiten recorrer y manipular los 
resultados de una consulta en una base de datos de manera iterativa.

Aunque pueden ser �tiles en algunos casos, tambi�n tienen algunas desventajas, como 
las siguientes:

Consumen recursos: Los cursores consumen memoria y recursos del servidor, lo que puede
ralentizar el rendimiento del sistema y afectar a otros procesos.

Pueden generar bloqueos: Cuando se utiliza un cursor para recorrer una tabla, esta se
bloquea para el resto de procesos, lo que puede generar bloqueos y retrasos en otras 
operaciones.

No escalan bien: Los cursores no escalan bien en sistemas con grandes vol�menes de datos,
ya que su capacidad para procesar grandes cantidades de informaci�n es limitada.
Pueden generar problemas de rendimiento: Si no se utilizan correctamente, los cursores 
pueden generar problemas de rendimiento en la base de datos, ya que aumentan el uso de 
CPU y la carga en el servidor.
*/

USE Northwind
GO

-------------------------------------------------------
DECLARE ucr_categoria CURSOR
FOR
    SELECT CategoryID, CategoryName, Description
    FROM Categories;

OPEN ucr_categoria;

FETCH NEXT FROM ucr_categoria;
WHILE @@FETCH_STATUS = 0
BEGIN
    FETCH NEXT FROM ucr_categoria;
    PRINT CONCAT('@@FETCH_STATUS: ', @@FETCH_STATUS)
END
CLOSE ucr_categoria;
DEALLOCATE ucr_categoria;
GO