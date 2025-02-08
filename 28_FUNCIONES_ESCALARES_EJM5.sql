/*
Calcular el total de ventas por cliente
*/

USE Northwind
GO
CREATE OR ALTER FUNCTION ufn_total_ventas_x_cliente
(
    @CustomerID nchar(5) --parametro de entrada
)
RETURNS MONEY --devolver el monto
AS
BEGIN
    RETURN
    (
        SELECT SUM(od.Quantity * od.UnitPrice * ( 1 - od.Discount))
        FROM Customers c
        INNER JOIN Orders o
        ON c.CustomerID = o.CustomerID
        INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
        WHERE c.CustomerID = @CustomerID
    );
END
GO
-----------------------------
SELECT dbo.ufn_total_ventas_x_cliente('ANTON') AS Ventas --ventas del cliente ANTON
GO
-----------------------------
SELECT [CustomerID]
      ,[CompanyName]
      ,[ContactName]
      ,[ContactTitle]
      ,[Address]
      ,[City]
      ,[Country]
      ,dbo.ufn_total_ventas_x_cliente([CustomerID]) AS Ventas
  FROM [dbo].[Customers]

GO