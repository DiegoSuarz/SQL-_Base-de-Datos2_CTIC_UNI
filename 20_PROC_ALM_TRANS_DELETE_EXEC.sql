USE Northwind
GO
--TRUNCATE TABLE [dbo].[tbl_error_usp];
GO
DECLARE @ProductID int = 11  --id del producto que se va a eliminar

SELECT *
FROM [Order Details]
WHERE OrderID = 10248;

SELECT *
FROM Products
WHERE ProductID = @ProductID;

DECLARE @RC int
DECLARE @OrderID int = 10248

-- TODO: Establezca los valores de los parámetros aquí.

EXECUTE @RC = [dbo].[usp_order_details_delete]
   @OrderID
  ,@ProductID


SELECT *
FROM Products
WHERE ProductID = @ProductID;
GO
SELECT *
FROM [Order Details]
WHERE OrderID = 10248;

-----------------------------------------
SELECT *
FROM tbl_error_usp
