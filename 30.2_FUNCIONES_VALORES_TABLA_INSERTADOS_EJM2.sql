/*
Funciones con valores de tabla insertados
*/

USE Northwind
GO

---------------------------------------------------------
CREATE OR ALTER FUNCTION uif_productos_x_codigo_categoria
(
    @CategoryID int

)
RETURNS TABLE
AS
RETURN
(
    SELECT
        [ProductID]
        ,[ProductName]
        ,dbo.ufn_proveedor([SupplierID]) AS Proveedor
        ,dbo.ufn_categoria([CategoryID]) AS Categoria
        ,[QuantityPerUnit]
        ,[UnitPrice]
        ,[UnitsInStock]
        ,[UnitsOnOrder]
        ,[ReorderLevel]
        ,[Discontinued]
    FROM [dbo].[Products]
    WHERE CategoryID = @CategoryID
)
GO

---------------------------------------------------------
SELECT *
FROM uif_productos_x_codigo_categoria(3);
GO