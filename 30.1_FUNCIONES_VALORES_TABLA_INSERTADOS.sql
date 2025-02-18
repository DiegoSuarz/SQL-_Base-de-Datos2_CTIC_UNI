/*
Funciones con valores de tabla insertados
*/

CREATE OR ALTER FUNCTION uif_pedidos_x_cliente
(
    @CustomerID NCHAR(5) --filtro por id de cliente
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        [OrderID]
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
      WHERE CustomerID = @CustomerID
)
GO
---------------------------------------------------
SELECT * FROM dbo.uif_pedidos_x_cliente('ERNSH') --filtro por id de cliente ERNSH