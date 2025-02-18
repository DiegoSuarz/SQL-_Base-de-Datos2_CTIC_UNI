--PROCEDIMIENTOS ALMACENADOS SIN PARÁMETROS

/*
Usando la base de datos Northwind
Crea un procedimiento almacenado
que muestre el stock de los productos
menores a 10 unidades
*/

USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_stock'
)
DROP PROCEDURE usp_stock
GO
CREATE PROCEDURE usp_stock
AS
BEGIN
    SELECT ProductID, ProductName, UnitsInStock AS Stock
    FROM Products
    WHERE UnitsInStock < 10
    ORDER BY 3 DESC
    RETURN 0
END
GO
EXECUTE usp_stock