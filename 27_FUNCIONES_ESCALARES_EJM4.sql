USE Northwind
GO
CREATE OR ALTER FUNCTION ufn_orders_cnt_dias_entrega
(
    @OrderID INT --parametro de entrada
)
RETURNS INT
AS
BEGIN
    DECLARE @cnt_day INT

    SET @cnt_day = --retorna la cantidad de dias de entrega
    (
        SELECT
            DATEDIFF
            (
                day,
                (SELECT [OrderDate] FROM Orders WHERE OrderID= @OrderID),
                (SELECT [ShippedDate] FROM Orders WHERE OrderID= @OrderID)
            )
    )
    RETURN @cnt_day; --parametro de salida
END
GO
USE [Northwind]
GO

SELECT [OrderID]
      ,[dbo].[ufn_customers_companyName]([CustomerID]) AS Cliente
      ,[dbo].[ufn_employees_nombre_empleado]([EmployeeID]) AS Empleado
     -- ,[OrderDate]
      ,[RequiredDate]
      ,[ShippedDate]
      , [dbo].[ufn_orders_cnt_dias_entrega]([OrderID]) AS [Días de entrega]
      ,[dbo].[ufn_shippers_companyname]([ShipVia]) AS Transportes
      ,[Freight]
      ,[ShipName]
      ,[ShipAddress]
      ,[ShipCity]
      ,[ShipRegion]
      ,[ShipPostalCode]
      ,[ShipCountry]
  FROM [dbo].[Orders]



-------------------------------------------------------------------------------------
--eliminando @cnt_day ya que no es necesario


  USE Northwind
GO
CREATE OR ALTER FUNCTION ufn_orders_cnt_dias_entrega
(
    @OrderID INT
)
RETURNS INT
AS
BEGIN
    RETURN
    (
        SELECT
            DATEDIFF
            (
                day,
                (SELECT [OrderDate] FROM Orders WHERE OrderID= @OrderID),
                (SELECT [ShippedDate] FROM Orders WHERE OrderID= @OrderID)
            )
    );
END
GO
SELECT [OrderID]
      ,[dbo].[ufn_customers_companyName]([CustomerID]) AS Cliente
      ,[dbo].[ufn_employees_nombre_empleado]([EmployeeID]) AS Empleado
      ,[OrderDate]
      ,[RequiredDate]
      ,[ShippedDate]
      , [dbo].[ufn_orders_cnt_dias_entrega]([OrderID]) AS [Días de entrega]
      ,[dbo].[ufn_shippers_companyname]([ShipVia]) AS Transportes
      ,[Freight]
      ,[ShipName]
      ,[ShipAddress]
      ,[ShipCity]
      ,[ShipRegion]
      ,[ShipPostalCode]
      ,[ShipCountry]
  FROM [dbo].[Orders]

GO