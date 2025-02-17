/*
Northwind: ¿Cómo se declara un parámetro de salida en un procedimiento almacenado?
*/
USE Northwind

--a.
CREATE OR ALTER PROCEDURE GetOrderCount @CustomerID NVARCHAR(5), @OrderCount INT OUTPUT
AS
BEGIN
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE CustomerID = @CustomerID;
END;

----------------------------------------------------------------------------------------

IF EXISTS
(
	SELECT NAME
	FROM SYS.procedures 
	WHERE NAME = 'GetOrderCount'
)
DROP PROCEDURE GetOrderCount
GO

CREATE PROCEDURE GetOrderCount @CustomerID NVARCHAR(5), @OrderCount INT OUTPUT
AS
BEGIN
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE CustomerID = @CustomerID;
END;
