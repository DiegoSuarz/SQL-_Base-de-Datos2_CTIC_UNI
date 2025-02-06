

USE Northwind
GO
------------------
SELECT * FROM [Order Details] WHERE OrderID = 10248 
SELECT * FROM Products WHERE ProductID = 11 
GO

------------------

DECLARE @ProductID INT = 11; --VARIABLE LAS VARIABLES LLEVAN PUNTO Y COMA

SELECT *
FROM [Order Details]
WHERE OrderID = 10248;

SELECT *
FROM Products
WHERE ProductID = @ProductID;

DECLARE @RC int
DECLARE @OrderID int = 10248;
DECLARE @UnitPrice money = 1
DECLARE @Quantity smallint = 100
DECLARE @Discount real = 1

-- TODO: Establezca los valores de los parámetros aquí.

EXECUTE @RC = usp_order_details_insert  
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