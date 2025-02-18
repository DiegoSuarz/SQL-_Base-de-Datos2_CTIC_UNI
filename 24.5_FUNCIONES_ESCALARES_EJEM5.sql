USE Northwind
GO

----------------------------------------
IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE
            xtype = 'FN'
        AND
            name = 'ufn_categoria'
)
DROP FUNCTION ufn_categoria
GO

----------------------------------------
CREATE FUNCTION ufn_categoria
(
    @CategoryID INT
)
RETURNS NVARCHAR(15)
AS
BEGIN
    DECLARE @categoria NVARCHAR(15);

    SELECT @categoria =[CategoryName]
    FROM [dbo].[Categories]
    WHERE [CategoryID] = @CategoryID

    RETURN @categoria;
END
GO

----------------------------------------
SELECT [ProductID]
      ,[ProductName]
      ,[SupplierID]
      ,[CategoryID]
      ,dbo.ufn_categoria([CategoryID]) AS Categoría
      ,[QuantityPerUnit]
      ,[UnitPrice]
      ,[UnitsInStock]
      ,[UnitsOnOrder]
      ,[ReorderLevel]
      ,[Discontinued]
  FROM [dbo].[Products]
GO