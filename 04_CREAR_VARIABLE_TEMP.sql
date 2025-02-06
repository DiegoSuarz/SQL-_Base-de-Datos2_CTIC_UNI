/*
TABLAS TEMPORALES:
Declaración de Variables de Tipo Tabla
Puedes declarar variables que actúan como tablas temporales.
TABLA TEMPORAL LOCAL:
*/


USE Northwind
GO
DECLARE @T TABLE
(
    [ProductID] [int]  NOT NULL,
    [ProductName] [nvarchar](40) NOT NULL,
    [Categoría] [nvarchar](15) NULL,
    [UnitPrice] [money] NULL,
    [UnitsInStock] [smallint] NULL
)


INSERT INTO @T
SELECT
    ProductID,
    ProductName,
    (SELECT CategoryName FROM Categories WHERE CategoryID = p.CategoryID) AS Categoría,
    UnitPrice,
    UnitsInStock
FROM Products p;
SELECT * FROM @T;