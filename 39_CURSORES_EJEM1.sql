/*
M�DULO 6: CURSORES
�Qu� son los cursores?
Los cursores en SQL Server 2022 son estructuras que permiten el 
manejo de filas de resultados de una consulta de manera secuencial.

A diferencia de las operaciones de conjunto t�picas en SQL, que 
procesan m�ltiples filas a la vez, los cursores permiten procesar 
fila por fila, lo que puede ser �til en ciertas situaciones.

Caracter�sticas de los cursores
	Iteraci�n: Permiten recorrer un conjunto de resultados fila por fila.
	Control: Ofrecen un control m�s granular sobre los datos, permitiendo 
			realizar operaciones espec�ficas en cada fila.
	Estado: Mantienen el estado de la posici�n actual en el conjunto de resultados.

Tipos de cursores
	Cursores est�ticos: Copian los datos de la consulta en el momento 
						de la apertura y no reflejan cambios posteriores.
	Cursores din�micos: Reflejan los cambios en los datos subyacentes a 
						medida que se navega por el cursor.
	Cursores de solo lectura: Permiten solo la lectura de datos, sin la 
							  posibilidad de hacer modificaciones.
	Cursores actualizables: Permiten la modificaci�n de datos en las filas
							del conjunto de resultados.
*/

--Ejemplo de creaci�n de un cursor b�sico

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