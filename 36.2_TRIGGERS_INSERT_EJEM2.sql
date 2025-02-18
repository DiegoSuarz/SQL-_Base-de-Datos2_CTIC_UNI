/*
M�DULO 3.- TRIGGERS O DESENCADENANTES
Un Trigger es un mecanismo que ofrece SQL Server para exigir reglas de negocio e 
integridad de datos.

Un desencadenante es un procedimiento almacenado de tipo especial que act�a 
autom�ticamente cuando se modifican los datos de la tabla.

Los desencadenantes se invocan en respuesta a las instrucciones INSERT, UPDATE y DELETE.

Un desencadenador puede consultar otras tablas e incluir instrucciones Transact-SQL 
complejas.

El desencadenante y la instrucci�n que la activa se tratan como una sola transacci�n 
que puede deshacerse desde el mismo desencadenante.

Si se detecta un error grave (por ejemplo, no hay suficiente espacio en disco), se 
deshace autom�ticamente toda la transacci�n.

Los desencadenantes pueden realizar cambios en cascada por medio de tablas relacionadas 
de la base de datos; sin embargo, estos cambios pueden ejecutarse de manera m�s eficaz 
mediante restricciones de integridad referencial en cascada.

Los desencadenantes pueden exigir restricciones m�s complejas que las restricciones 
CHECK

Los desencadenantes pueden evaluar el estado de una tabla antes y despu�s de realizar
una modificaci�n de datos y actuar en funci�n de la diferencia.

Varios desencadenantes del mismo tipo (INSERT, UPDATE o DELETE) en una tabla permiten
realizar distintas acciones en respuesta a una misma instrucci�n de modificaci�n.

Tanto las restricciones como los desencadenantes ofrecen ventajas espec�ficas que 
resultan �tiles en determinadas situaciones.

La principal ventaja de los desencadenantes consiste en que pueden contener una l�gica
de proceso compleja que utilice c�digo Transact-SQL.

Por tanto, los desencadenante permiten toda la funcionalidad de las restricciones; sin
embargo, no son siempre el mejor m�todo para realizar una determinada funci�n.

Dise�o de Desencadenantes
Podemos dise�ar desencadenantes INSTEAD OF y AFTER.

Los desencadenantes INSTEAD OF se ejecutan antes de la instrucci�n que lo invoca y 
pueden dise�arse para tablas o vistas.

Los desencadenantes INSTEAD OF en vistas con una o m�s tablas base, pueden ampliar 
los tipos de actualizaciones que puede admitir una vista.

Los desencadenadores AFTER se ejecutan despu�s de llevar a cabo una acci�n de las
instrucciones INSERT, UPDATE o DELETE.

La especificaci�n de AFTER produce el mismo efecto que especificar FOR, que es la 
�nica opci�n disponible en las versiones anteriores de SQL Server.

El desencadenador AFTER s�lo puede especificarse en tablas.

Funci�n						AFTER																		INSTEAD OF
Aplicado a					Tablas																		Tablas y Vistas

Cantidad					Varios por cada acci�n de desencadenamiento (INSERT, UPDATE Y DELETE)		Uno por cada acci�n de desencadenamiento (INSERT, UPDATE Y DELETE)
Referencias en cascada		No se aplica ninguna restricci�n											No se permiten en tablas que sean destinos de restricciones de integridad referencial

Ejecuci�n					Despu�s:																	Antes:
							Procesamiento de restricciones												Procesamiento de restricciones
							Creaci�n de las tablas *inserted** y deleted								Lugar de:
							la acci�n de desencadenamiento												La acci�n de desencadenamiento

Despu�s:
Creaci�n de las tableas 
inserted y deleted	
*/
USE Northwind
GO
----------------------

IF EXISTS
(
    SELECT *
    FROM sys.triggers
    WHERE name = 'utr_order_details_insert'
)
DROP TRIGGER utr_order_details_insert
GO

-------------------------------------------------
CREATE TRIGGER utr_order_details_insert
ON  [dbo].[Order Details]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON; --es un comando en SQL Server que controla si se muestra el n�mero de filas afectadas por una consulta.

    PRINT 'SE HA EJECUTADO UN TRIGGER AFTER INSERT' 
    ROLLBACK TRANSACTION  --Toda la transacci�n se deshace y el lote de comandos se aborta. GENERA ERROR
END
GO

------------------------------------------------------------------------------------
SELECT * FROM [dbo].[Order Details]
WHERE OrderID = 10248
GO
INSERT INTO [dbo].[Order Details]
(
    [OrderID]
    ,[ProductID]
    ,[UnitPrice]
    ,[Quantity]
    ,[Discount]
)
VALUES
(
    10248
    ,1
    ,18
    ,9
    ,0
)
GO
SELECT * FROM [dbo].[Order Details]
WHERE OrderID = 10248
GO
