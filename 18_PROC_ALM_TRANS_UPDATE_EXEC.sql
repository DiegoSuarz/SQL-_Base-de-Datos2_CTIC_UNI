--PARA HACER PRUEBAS CON EL UPDATE

USE Northwind
GO
DECLARE @ProductID INT = 2;

SELECT *
FROM [Order Details]
WHERE OrderID = 10248;

SELECT *
FROM Products
WHERE ProductID = @ProductID;

DECLARE @RC int
DECLARE @OrderID int = 10248;
DECLARE @UnitPrice money = 22
DECLARE @Quantity smallint = 5
DECLARE @Discount real = 0.13

-- TODO: Establezca los valores de los parámetros aquí.

EXECUTE @RC = usp_order_details_update  
    @OrderID
  ,@ProductID
  ,@UnitPrice
  ,@Quantity
  ,@Discount;

SELECT *
FROM Products
WHERE ProductID = @ProductID;
GO
SELECT *
FROM [Order Details]
WHERE OrderID = 10248;
GO
-----------------------------------------------------------------------------------------
SELECT *
FROM tbl_error_usp
