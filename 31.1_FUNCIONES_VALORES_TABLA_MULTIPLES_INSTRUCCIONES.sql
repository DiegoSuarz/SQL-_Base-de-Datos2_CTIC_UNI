/*
Funciones con valores de tabla de múltiples instrucciones
*/

USE Northwind
GO

IF EXISTS
(
    SELECT name
    FROM sys.tables
    WHERE name = 'X'
)
DROP TABLE[dbo].[X]
GO

USE [Northwind]
GO

SELECT [OrderID]
      ,[CustomerID]
      ,[EmployeeID]
      ,[OrderDate]
      ,[RequiredDate]
      ,[ShippedDate]
      ,[ShipVia]
      ,[Freight]
      ,[ShipName]
      ,[ShipAddress]
      ,[ShipCity]
      ,[ShipRegion]
      ,[ShipPostalCode]
      ,[ShipCountry]
	INTO [dbo].[X]
  FROM [dbo].[Orders]
 GO

 /*
 -----------------------------------------------
CREATE TABLE [dbo].[X](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
    [Cliente] [nvarchar](40) NULL,
    [Empleado] [nvarchar](45) NULL,
    [OrderDate] [datetime] NULL,
    [RequiredDate] [datetime] NULL,
    [ShippedDate] [datetime] NULL,
    [Días de entrega] [int] NULL,
    [Transportes] [nvarchar](40) NULL,
    [Freight] [money] NULL,
    [ShipName] [nvarchar](40) NULL,
    [ShipAddress] [nvarchar](60) NULL,
    [ShipCity] [nvarchar](15) NULL,
    [ShipRegion] [nvarchar](15) NULL,
    [ShipPostalCode] [nvarchar](10) NULL,
    [ShipCountry] [nvarchar](15) NULL

) ON [PRIMARY]
GO
*/
-------------------------------------------------------------

CREATE OR ALTER FUNCTION  utf_pedidos_x_cliente
(
    @CustomerID NCHAR(5)
)
RETURNS
@T TABLE
(
    [OrderID] [int] NOT NULL,
    [Cliente] [nvarchar](40) NULL,
    [Empleado] [nvarchar](45) NULL,
    [OrderDate] [datetime] NULL,
    [RequiredDate] [datetime] NULL,
    [ShippedDate] [datetime] NULL,
    [Días de entrega] [int] NULL,
    [Transportes] [nvarchar](40) NULL,
    [Freight] [money] NULL,
    [ShipName] [nvarchar](40) NULL,
    [ShipAddress] [nvarchar](60) NULL,
    [ShipCity] [nvarchar](15) NULL,
    [ShipRegion] [nvarchar](15) NULL,
    [ShipPostalCode] [nvarchar](10) NULL,
    [ShipCountry] [nvarchar](15) NULL
)
AS
BEGIN

    INSERT INTO @T
    SELECT
        [OrderID]
        ,[dbo].[ufn_customers_companyName]([CustomerID]) AS Cliente
        ,[dbo].[ufn_employees_nombre_empleado]([EmployeeID]) AS Empleado
        ,[OrderDate]
        ,[RequiredDate]
        ,[ShippedDate]
        ,[dbo].[ufn_orders_cnt_dias_entrega]([OrderID]) AS [Días de entrega]
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

    RETURN
END
GO

----------------------------------------------------------------------------------
SELECT * FROM [dbo].[utf_pedidos_x_cliente]('ERNSH')
GO