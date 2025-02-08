/*
Total de productos vendidos
Calcular el total de productos vendidos si se conoce el número
del mes y el año respectivamente
*/

USE Northwind
GO

CREATE OR ALTER FUNCTION ufn_total_productos_vendidos_x_mes_y_year
(
    @mes INT,
    @yea INT
)
RETURNS INT
AS
BEGIN
    RETURN
    (
        SELECT SUM(od.Quantity)
        FROM Orders o
        INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
        WHERE
                YEAR(o.OrderDate) = @yea
            AND
                MONTH(o.OrderDate) = @mes
    )
END
GO

------------------------------------------------------
--total de productos vendidos en octubre de 1997 (10/97)
SELECT dbo.ufn_total_productos_vendidos_x_mes_y_year(10, 1997) AS [Total de productos vendidos]
GO