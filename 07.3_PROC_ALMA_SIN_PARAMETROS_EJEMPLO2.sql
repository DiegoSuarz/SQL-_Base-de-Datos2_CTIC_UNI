/*
Usando la base de datos Northwind
Crea un procedimiento almacenado
que muestre las ventas por año.
*/
USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_venta_x_year'
)
DROP PROCEDURE usp_venta_x_year
GO
-----
CREATE PROCEDURE usp_venta_x_year
AS
BEGIN
    SELECT
        YEAR(OrderDate) AS Año,
        CONVERT(DECIMAL(12,2), SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))) AS Ventas
    FROM Orders o
    INNER JOIN [Order Details] od
    ON o.OrderID = od.OrderID
    GROUP BY YEAR(OrderDate)
    ORDER BY 1 DESC
END
GO

------------------------------------------------
EXEC usp_venta_x_year
GO