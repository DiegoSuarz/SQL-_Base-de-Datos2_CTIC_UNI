/*
NorthwindSQL: ¿Cuál es la sintaxis correcta para crear un procedimiento 
almacenado que devuelva el total de las ventas?
*/


--c.
CREATE OR ALTER PROCEDURE usp_ventas_2c
AS
BEGIN
    SELECT CONVERT(DECIMAL(19,2), SUM(Quantity * UnitPrice * (1 - Discount))) AS Ventas
    FROM [Order Details]
    RETURN 0
END

exec usp_ventas_2c



