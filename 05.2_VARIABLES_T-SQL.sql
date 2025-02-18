/*
CREACIÓN DE VARIABLES T-SQL
*/

USE Northwind
GO
-- Calcular el promedio de precios
-- de los productos
DECLARE @Promedio FLOAT;

SELECT @Promedio = AVG(UnitPrice)
FROM Products;

SELECT @Promedio AS Promedio;


------------------------------------------------
USE Northwind
GO
-- Calcular el promedio de precios
-- de los productos
DECLARE @Promedio FLOAT;

SET @Promedio =
(
    SELECT AVG(UnitPrice)
    FROM Products
)
SELECT @Promedio AS Promedio;


------------------------------------------------
USE Northwind
GO
-- Calcular el promedio de precios
-- de los productos
DECLARE @Promedio FLOAT =
(
    SELECT AVG(UnitPrice)
    FROM Products
)
SELECT @Promedio AS Promedio;