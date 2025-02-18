/*
MÓDULO 3.- TRIGGERS O DESENCADENANTES
Un Trigger es un mecanismo que ofrece SQL Server para exigir reglas de negocio e 
integridad de datos.

Un desencadenante es un procedimiento almacenado de tipo especial que actúa 
automáticamente cuando se modifican los datos de la tabla.

Los desencadenantes se invocan en respuesta a las instrucciones INSERT, UPDATE y DELETE.

Un desencadenador puede consultar otras tablas e incluir instrucciones Transact-SQL 
complejas.

El desencadenante y la instrucción que la activa se tratan como una sola transacción 
que puede deshacerse desde el mismo desencadenante.

Si se detecta un error grave (por ejemplo, no hay suficiente espacio en disco), se 
deshace automáticamente toda la transacción.

Los desencadenantes pueden realizar cambios en cascada por medio de tablas relacionadas 
de la base de datos; sin embargo, estos cambios pueden ejecutarse de manera más eficaz 
mediante restricciones de integridad referencial en cascada.

Los desencadenantes pueden exigir restricciones más complejas que las restricciones 
CHECK

Los desencadenantes pueden evaluar el estado de una tabla antes y después de realizar
una modificación de datos y actuar en función de la diferencia.

Varios desencadenantes del mismo tipo (INSERT, UPDATE o DELETE) en una tabla permiten
realizar distintas acciones en respuesta a una misma instrucción de modificación.

Tanto las restricciones como los desencadenantes ofrecen ventajas específicas que 
resultan útiles en determinadas situaciones.

La principal ventaja de los desencadenantes consiste en que pueden contener una lógica
de proceso compleja que utilice código Transact-SQL.

Por tanto, los desencadenante permiten toda la funcionalidad de las restricciones; sin
embargo, no son siempre el mejor método para realizar una determinada función.

Diseño de Desencadenantes
Podemos diseñar desencadenantes INSTEAD OF y AFTER.

Los desencadenantes INSTEAD OF se ejecutan antes de la instrucción que lo invoca y 
pueden diseñarse para tablas o vistas.

Los desencadenantes INSTEAD OF en vistas con una o más tablas base, pueden ampliar 
los tipos de actualizaciones que puede admitir una vista.

Los desencadenadores AFTER se ejecutan después de llevar a cabo una acción de las
instrucciones INSERT, UPDATE o DELETE.

La especificación de AFTER produce el mismo efecto que especificar FOR, que es la 
única opción disponible en las versiones anteriores de SQL Server.

El desencadenador AFTER sólo puede especificarse en tablas.

Función						AFTER																		INSTEAD OF
Aplicado a					Tablas																		Tablas y Vistas

Cantidad					Varios por cada acción de desencadenamiento (INSERT, UPDATE Y DELETE)		Uno por cada acción de desencadenamiento (INSERT, UPDATE Y DELETE)
Referencias en cascada		No se aplica ninguna restricción											No se permiten en tablas que sean destinos de restricciones de integridad referencial

Ejecución					Después:																	Antes:
							Procesamiento de restricciones												Procesamiento de restricciones
							Creación de las tablas *inserted** y deleted								Lugar de:
							la acción de desencadenamiento												La acción de desencadenamiento

Después:
Creación de las tableas 
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
    SET NOCOUNT ON; --es un comando en SQL Server que controla si se muestra el número de filas afectadas por una consulta.

    PRINT 'SE HA EJECUTADO UN TRIGGER AFTER INSERT' 
    ROLLBACK TRANSACTION  --Toda la transacción se deshace y el lote de comandos se aborta. GENERA ERROR
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
