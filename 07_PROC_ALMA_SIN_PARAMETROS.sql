/*
Procedimientos Almacenados Sin Parámetros
Los procedimientos almacenados sin parámetros son aquellos que no requieren 
valores de entrada para ser ejecutados. No requieren variables

Estos procedimientos pueden ser utilizados para realizar tareas específicas, 
como consultar datos, realizar actualizaciones o ejecutar cálculos, sin 
necesidad de recibir información externa.
*/

/*
Northwind: Procedimiento almacenado para consultar
el stock de los productos <= 10
*/

USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_products_stock'
)
DROP PROCEDURE usp_products_stock --ELIMINAR PROCEDIMIENTO ALMACENADO
GO
----- CREAR PROCEDIMIENTO ALMACENADO
CREATE PROCEDURE usp_products_stock 
AS
BEGIN
    SELECT
        ProductID AS [Código del producto],
        ProductName AS Producto,
        UnitsInStock AS Stock
    FROM products
    WHERE UnitsInStock<=10
    ORDER BY 3 DESC
    RETURN 0
END
GO
-----
DECLARE @ERROR AS INT --ERROR PRODUCIDO EN EL PROCEDIMIENTO ALMACENADO
EXEC @ERROR = usp_products_stock
SELECT @ERROR AS Error
GO