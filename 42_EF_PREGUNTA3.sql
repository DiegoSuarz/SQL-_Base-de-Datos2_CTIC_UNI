--NorthwindSQL: �Cu�l es la sintaxis correcta para crear un procedimiento almacenado que 
--devuelva el total de las ventas por categor�as?


--b.
CREATE OR ALTER PROCEDURE usp_ventas_b
AS
BEGIN
    SELECT 
        Categor�a, 
        CONVERT(DECIMAL(12,2), SUM(Cantidad * Precio * ( 1- Descuento))) AS Ventas
    FROM Almacen.Productos p
    INNER JOIN ventas.[Detalles de pedido] dp
    ON p.Id = dp.[Id de producto]
    GROUP BY Categor�a
    RETURN 0
END

exec usp_ventas_b

-----------------------------------------------------------------------------------------

--d.
CREATE OR ALTER PROCEDURE usp_ventas_d
AS
BEGIN
    SELECT Categor�a, Cantidad * Precio * ( 1- Descuento) AS Ventas
    FROM Almacen.Productos p
    INNER JOIN ventas.[Detalles de pedido] dp
    ON p.Id = dp.[Id de producto]
    RETURN 0
END

exec usp_ventas_d



