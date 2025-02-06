/*
TABLAS TEMPORALES:
Declaraci�n de Variables de Tipo Tabla
Puedes declarar variables que act�an como tablas temporales.
TABLA TEMPORAL LOCAL:
*/


USE Northwind
GO
DECLARE @T TABLE
(
    [ProductID] [int]  NOT NULL,
    [ProductName] [nvarchar](40) NOT NULL,
    [Categor�a] [nvarchar](15) NULL,
    [UnitPrice] [money] NULL,
    [UnitsInStock] [smallint] NULL
)


INSERT INTO @T
SELECT
    ProductID,
    ProductName,
    (SELECT CategoryName FROM Categories WHERE CategoryID = p.CategoryID) AS Categor�a,
    UnitPrice,
    UnitsInStock
FROM Products p;
SELECT * FROM @T;