USE Northwind
GO
CREATE OR ALTER FUNCTION ufn_shippers_companyname
(
    @ShipperID INT
)
RETURNS NVARCHAR(40) --tipo de dato que va a devolver la funcion (nombre de la compañia)
AS
BEGIN
    DECLARE @CompanyName  NVARCHAR(40) =
    (
        SELECT CompanyName
        FROM [dbo].[Shippers]
        WHERE [ShipperID] = @ShipperID
    )
    RETURN @CompanyName
END
GO

----------------------------------------------------------
SELECT [OrderID]
      ,[dbo].[ufn_customers_companyName]([CustomerID]) AS Cliente		--funcion
      ,[dbo].[ufn_employees_nombre_empleado]([EmployeeID]) AS Empleado	--funcion
      --,[OrderDate]
      --,[RequiredDate]
      --,[ShippedDate]
      ,[dbo].[ufn_shippers_companyname]([ShipVia]) AS Transporte		--funcion
      ,[Freight]
      ,[ShipName]
      ,[ShipAddress]
      ,[ShipCity]
      ,[ShipRegion]
      ,[ShipPostalCode]
      ,[ShipCountry]
  FROM [dbo].[Orders]

GO