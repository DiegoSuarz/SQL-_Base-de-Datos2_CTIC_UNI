--ENVIAR INFORMACION EXCEL

SELECT *
FROM OPENROWSET
(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0 Xml;Database=C:\bd\data.xlsx',
    DATA$ --HOJA DE EXCEL
);

--------------------------------------------------------------
USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.tables
    WHERE name = 'tbl_ventas'
)
DROP TABLE tbl_ventas
GO
/*CREATE TABLE tbl_ventas
(
	FECHA	DATE,
    ZONA VARCHAR(5),
    RUC CHAR(11),
    [RAZON SOCIAL] VARCHAR(150),
    VENTAS MONEY,
    COSTOS MONEY
)
GO
*/
SELECT
    CONVERT(DATE,FECHA) AS FECHA,
    CONVERT(VARCHAR(5),ZONA) AS ZONA,
    CONVERT(CHAR(11), CONVERT(DECIMAL(11,0),RUC)) AS RUC,
    CONVERT(VARCHAR(150),[RAZON SOCIAL]) AS [RAZON SOCIAL],
    CONVERT( MONEY, VENTAS ) AS VENTAS,
    CONVERT( MONEY, COSTOS ) AS COSTOS
INTO  tbl_ventas
FROM OPENROWSET
(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0 Xml;Database=C:\bd\data.xlsx',
    DATA$
);