/*
Trigger por actualización: deleted y inserted
*/

USE Northwind
GO
---------------------------------------------------
IF EXISTS
(
    SELECT *
    FROM sys.triggers
    WHERE name = 'utr_order_details_update'
)
DROP TRIGGER utr_order_details_update
GO

---------------------------------------------------
CREATE TRIGGER utr_order_details_update
ON  [dbo].[Order Details]
AFTER UPDATE
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


    DECLARE @OrderID                int;
    DECLARE @ProductID                int;
    DECLARE @UnitPrice_del            money;
    DECLARE @Quantity_del            smallint;
    DECLARE @Discount_del            real;

    DECLARE @UnitPrice_ins            money;
    DECLARE @Quantity_ins            smallint;
    DECLARE @Discount_ins            real;

    DECLARE @Precio                    money;
    DECLARE @Stock                    smallint;
    DECLARE @Estado                    bit;    

    DECLARE @msgError            nvarchar(4000);

    -- ***************************

    SELECT
        @OrderID = [OrderID]
        ,@ProductID = [ProductID]
        ,@UnitPrice_del = [UnitPrice]
        ,@Quantity_del = [Quantity]
        ,@Discount_del = [Discount]
    FROM deleted;

    SELECT
        @OrderID = [OrderID]
        ,@ProductID = [ProductID]
        ,@UnitPrice_ins = [UnitPrice]
        ,@Quantity_ins = [Quantity]
        ,@Discount_ins = [Discount]
    FROM inserted;
    -- ***************************


    BEGIN TRY
        UPDATE [dbo].[Products]
        SET [UnitsInStock] += @Quantity_del
        WHERE ProductID = @ProductID;

        SELECT
            @Precio = [UnitPrice]
            ,@Stock = [UnitsInStock]
            ,@Estado = [Discontinued]
        FROM [dbo].[Products]
        WHERE ProductID = @ProductID


        IF @Quantity_ins > @Stock
        BEGIN
            SET @msgError = CONCAT('ERROR: La cantidad solicitada ', @Quantity_ins, ' es mayor que el stock: ', @Stock);
            THROW 51001, @msgError, 1;
        END

        IF NOT ((@UnitPrice_ins*(1-@Discount_ins) <= @Precio) AND @Discount_ins <= 10.0/100.0)
        BEGIN
            SET @msgError = CONCAT('ERROR: El precio del producto', @UnitPrice_ins*(1-@Discount_ins), ' < ', @Precio);
            THROW 51002, @msgError, 1;
        END

        IF @Estado != 0
        BEGIN
            SET @msgError = 'ERROR: EL PRODUCTO SE ENCUENTRA DESCONTINUADO';
            THROW 51003, @msgError, 1;
        END

        UPDATE [dbo].[Products]
        SET [UnitsInStock] -= @Quantity_ins
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

---------------------------------------------------
--EJECUCION DE TRIGGER:
SELECT *
FROM [dbo].[Order Details]
WHERE OrderID = 10248
GO
SELECT * FROM Products
WHERE ProductID = 1
GO
UPDATE [dbo].[Order Details]
   SET
       [UnitPrice] = 17
      ,[Quantity] = 7
      ,[Discount] = 0
 WHERE
        [OrderID] = 10248
    AND
        [ProductID] = 1
GO
SELECT * FROM Products
WHERE ProductID = 1
GO
SELECT *
FROM [dbo].[Order Details]
WHERE OrderID = 10248
GO
