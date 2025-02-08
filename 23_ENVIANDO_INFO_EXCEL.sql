/*
ENVÍO DE CONSULTA SQL A EXCEL
USANDO PROCEDIMIENTOS ALMACENADOS
*/

USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_envio_stock'
)
DROP PROCEDURE usp_envio_stock
GO
--CREAR PRODIMIENTO ALMACENADO
CREATE PROCEDURE usp_envio_stock
AS
BEGIN

DECLARE @strDOS VARCHAR(400)
DECLARE @name VARCHAR(400) =
(
    SELECT
    'C:\bd\northwind_stock_'
    +
    REPLACE
    (
    REPLACE
    (
    REPLACE
    (
    REPLACE
    (
        CONVERT(VARCHAR(200), GetDate(), 121)
        , '-', '_'
    )
    , ' ', '_'
    )
    , ':', '_'
    )
    , '.', '_'
    )+'.xlsx'
)

SET @strDOS = CONCAT('COPY C:\bd\plantilla_stock.xlsx ', @name, ' /Y');
--------------------------------------------------------------------------------------
EXECUTE xp_cmdshell @strDOS, no_output;

    SELECT
        ProductID AS Código,
        ProductName AS Artículo,
        UnitsInStock AS Stock
    FROM Products
    WHERE UnitsInStock <= 10
    ORDER BY 3 Desc
END
GO
usp_envio_stock