/*
MÓDULO 6: CURSORES
¿Qué son los cursores?
Los cursores en SQL Server 2022 son estructuras que permiten el 
manejo de filas de resultados de una consulta de manera secuencial.

A diferencia de las operaciones de conjunto típicas en SQL, que 
procesan múltiples filas a la vez, los cursores permiten procesar 
fila por fila, lo que puede ser útil en ciertas situaciones.

Características de los cursores
	Iteración: Permiten recorrer un conjunto de resultados fila por fila.
	Control: Ofrecen un control más granular sobre los datos, permitiendo 
			realizar operaciones específicas en cada fila.
	Estado: Mantienen el estado de la posición actual en el conjunto de resultados.

Tipos de cursores
	Cursores estáticos: Copian los datos de la consulta en el momento 
						de la apertura y no reflejan cambios posteriores.
	Cursores dinámicos: Reflejan los cambios en los datos subyacentes a 
						medida que se navega por el cursor.
	Cursores de solo lectura: Permiten solo la lectura de datos, sin la 
							  posibilidad de hacer modificaciones.
	Cursores actualizables: Permiten la modificación de datos en las filas
							del conjunto de resultados.
*/

--Ejemplo de creación de un cursor básico

USE Northwind
GO

DECLARE ucr_categories CURSOR FOR  --nombre de la tabla que se va a recorrer
SELECT
    [CategoryID]
    ,[CategoryName]
    ,[Description]
FROM [dbo].[Categories];

OPEN ucr_categories;

FETCH NEXT FROM ucr_categories;
WHILE @@FETCH_STATUS = 0
    FETCH NEXT FROM ucr_categories;

CLOSE ucr_categories;
DEALLOCATE ucr_categories;