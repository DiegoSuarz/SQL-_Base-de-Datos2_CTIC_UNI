USE Northwind
GO

------------------------------------------
IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE
            xtype = 'FN'
        AND
            name = 'ufn_proveedor'
)
DROP FUNCTION ufn_proveedor
GO

------------------------------------------
CREATE FUNCTION ufn_proveedor
(
    @SupplierID INT
)
RETURNS NVARCHAR(15)
AS
BEGIN
    DECLARE @Proveedor NVARCHAR(15);

    SELECT @Proveedor = [CompanyName]
    FROM [dbo].[Suppliers]
    WHERE [SupplierID] = @SupplierID

    RETURN @Proveedor;
END
GO

------------------------------------------
SELECT [ProductID]
      ,[ProductName]
      ,dbo.ufn_proveedor([SupplierID]) AS Proveedor
      ,dbo.ufn_proveedor([CategoryID]) AS Categoría
      ,[QuantityPerUnit]
      ,[UnitPrice]
      ,[UnitsInStock]
      ,[UnitsOnOrder]
      ,[ReorderLevel]
      ,[Discontinued]
  FROM [dbo].[Products]
GO