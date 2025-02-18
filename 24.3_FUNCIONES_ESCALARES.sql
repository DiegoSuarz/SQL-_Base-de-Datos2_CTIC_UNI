/*
M�DULO 2.- FUNCIONES
Las funciones en SQL Server son objetos que permiten encapsular una l�gica 
reutilizable y devolver un resultado.

Pueden ser utilizadas en consultas SQL, en procedimientos almacenados y en 
otros contextos.

SQL Server admite varios tipos de funciones, cada una con caracter�sticas y 
prop�sitos distintos.

Funciones Escalares
Devuelven un solo valor basado en la entrada proporcionada.

Se pueden utilizar en cualquier lugar donde se permita una expresi�n.
*/

USE Northwind
GO

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

--------------
CREATE FUNCTION ufn_categoria
(
    @CategoryID INT
)
RETURNS NVARCHAR(15)
AS
BEGIN
    RETURN
    (
        SELECT [CategoryName]
        FROM [dbo].[Categories]
        WHERE [CategoryID] = @CategoryID
    )
END
GO


----------------------------------------
--EJECUCION
SELECT [ProductID]
      ,[ProductName]
      ,[SupplierID]
      ,[CategoryID]
      ,dbo.ufn_categoria([CategoryID]) AS Categor�a --EJECUTAR FUNCION
      ,[QuantityPerUnit]
      ,[UnitPrice]
      ,[UnitsInStock]
      ,[UnitsOnOrder]
      ,[ReorderLevel]
      ,[Discontinued]
  FROM [dbo].[Products]
GO