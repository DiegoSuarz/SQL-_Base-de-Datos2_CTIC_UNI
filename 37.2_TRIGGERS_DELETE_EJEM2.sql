/*
Trigger por eliminación: deleted
*/

USE Northwind
GO

IF EXISTS
(
    SELECT *
    FROM sys.triggers
    WHERE name = 'utr_order_details_delete'
)
DROP TRIGGER utr_order_details_delete
GO

----------------------------------------------
CREATE TRIGGER utr_order_details_delete
ON  [dbo].[Order Details]
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber            int
    DECLARE @ErrorSeverity            int
    DECLARE @ErrorState                int
    DECLARE @ErrorProcedure            nvarchar(128)
    DECLARE @ErrorLine                int
    DECLARE @ErrorMessage            nvarchar(4000)
    DECLARE @ErrorDate                datetime


    DECLARE @OrderID            int;
    DECLARE @ProductID            int;
    DECLARE @UnitPrice            money;
    DECLARE @Quantity            smallint;
    DECLARE @Discount            real;

    DECLARE @Precio                money;
    DECLARE @Stock                smallint;
    DECLARE @Estado                bit;    

    DECLARE @msgError            nvarchar(4000);

    -- ***************************
    SELECT
        @OrderID = [OrderID]
        ,@ProductID = [ProductID]
        ,@UnitPrice = [UnitPrice]
        ,@Quantity = [Quantity]
        ,@Discount = [Discount]
    FROM deleted;
    -- ***************************
    BEGIN TRY
        UPDATE [dbo].[Products]
        SET [UnitsInStock] += @Quantity
        WHERE ProductID = @ProductID;

    END TRY
    BEGIN CATCH
        print(6)
        SELECT
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorDate = GETDATE();

        ROLLBACK TRANSACTION
        print(7)
         INSERT INTO [dbo].[tbl_error_usp]
                (
                    [ErrorNumber]
                    ,[ErrorSeverity]
                    ,[ErrorState]
                    ,[ErrorProcedure]
                    ,[ErrorLine]
                    ,[ErrorMessage]
                    ,[ErrorDate]
                )
                VALUES
                (
                    @ErrorNumber
                    ,@ErrorSeverity
                    ,@ErrorState
                    ,@ErrorProcedure
                    ,@ErrorLine
                    ,@ErrorMessage
                    ,@ErrorDate
                )
                print(8)
    END CATCH

END
GO

------------------------------------------------------------


SELECT *
FROM Products
WHERE ProductID = 1
GO
SELECT *
FROM [dbo].[Order Details]
WHERE
        OrderID = 10248
GO
DELETE FROM [dbo].[Order Details]
WHERE
        OrderID = 10248
    AND
        ProductID = 1
GO
SELECT *
FROM Products
WHERE ProductID = 1
GO
SELECT *
FROM [dbo].[Order Details]
WHERE
        OrderID = 10248
GO