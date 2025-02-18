/*
Creación de la tabla de errores de triggers
Trigger por inserción: inserted
*/

USE Northwind
GO

--------------------------------------------------------------------
--TABLA DE ERRORES

IF EXISTS
(
	SELECT name
	FROM sys.tables
	WHERE name = 'tbl_error_trigger'
)
DROP TABLE tbl_error_trigger
GO

SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_STATE() AS ErrorState,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage,
    GETDATE() AS ErrorDate
INTO tbl_error_trigger;

--------------------------------------------------------------------
ALTER TRIGGER utr_order_details_insert
ON  [dbo].[Order Details]
AFTER INSERT
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
    FROM inserted;
    -- ***************************

    SELECT
        @Precio = [UnitPrice]
        ,@Stock = [UnitsInStock]
        ,@Estado = [Discontinued]
    FROM [dbo].[Products]
    WHERE ProductID = @ProductID

    BEGIN TRY
        PRINT(1)
        IF @Quantity > @Stock
        BEGIN
            SET @msgError = CONCAT('ERROR: La cantidad solicitada ', @Quantity, ' es mayor que el stock: ', @Stock);
            THROW 51001, @msgError, 1;
        END

        PRINT(2)
        IF NOT ((@UnitPrice*(1-@Discount) <= @Precio) AND @Discount <= 10.0/100.0)
        BEGIN
            SET @msgError = CONCAT('ERROR: El precio del producto', @UnitPrice*(1-@Discount), ' < ', @Precio);
            THROW 51002, @msgError, 1;
        END

        PRINT(3)
        IF @Estado != 0
        BEGIN
            SET @msgError = 'ERROR: EL PRODUCTO SE ENCUENTRA DESCONTINUADO';
            THROW 51003, @msgError, 1;
        END

        PRINT(4)
        UPDATE [dbo].[Products]
        SET [UnitsInStock] -= @Quantity
        WHERE ProductID = @ProductID;

        PRINT(5)

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


--------------------------------------------------------------------
SELECT * FROM [dbo].[Order Details]
WHERE OrderID = 10248
GO
SELECT [ProductID]
      ,[ProductName]
      ,[UnitPrice]
      ,[UnitsInStock]
      ,[Discontinued]
FROM [dbo].[Products]
WHERE ProductID = 1
GO
INSERT INTO [dbo].[Order Details]
(
    [OrderID]
    ,[ProductID]
    ,[UnitPrice]
    ,[Quantity]
    ,[Discount]
)
VALUES
(
    10248
    ,1
    ,18
    ,9
    ,0
)
GO
SELECT * FROM [dbo].[Order Details]
WHERE OrderID = 10248
GO
SELECT [ProductID]
      ,[ProductName]
      ,[UnitPrice]
      ,[UnitsInStock]
      ,[Discontinued]
FROM [dbo].[Products]
WHERE ProductID = 1
GO


