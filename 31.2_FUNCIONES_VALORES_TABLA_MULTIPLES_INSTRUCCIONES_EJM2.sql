/*
Funciones con valores de tabla de múltiples instrucciones
*/


CREATE OR ALTER FUNCTION utf_productos_x_codigo_categoria
(
    @CategoryID INT
)
RETURNS @T TABLE
(
    [ProductID] [int]  NOT NULL,
    [ProductName] [nvarchar](40) NOT NULL,
    [Proveedor] [nvarchar](15) NULL,
    [Categoria] [nvarchar](15) NULL,
    [QuantityPerUnit] [nvarchar](20) NULL,
    [UnitPrice] [money] NULL,
    [UnitsInStock] [smallint] NULL,
    [UnitsOnOrder] [smallint] NULL,
    [ReorderLevel] [smallint] NULL,
    [Discontinued] [bit] NOT NULL
)
AS
BEGIN
    INSERT INTO @T
    (
        [ProductID]
        ,[ProductName]
        ,[Proveedor]
        ,[Categoria]
        ,[QuantityPerUnit]
        ,[UnitPrice]
        ,[UnitsInStock]
        ,[UnitsOnOrder]
        ,[ReorderLevel]
        ,[Discontinued]
    )
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
    FROM Products
    WHERE CategoryID = @CategoryID;
    RETURN
END
GO

--------------------------------------------------------
SELECT * FROM dbo.utf_productos_x_codigo_categoria(6);
GO
