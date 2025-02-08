-- Procedimiento Almacenado de Modificación

USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_order_details_update'
)
DROP PROCEDURE usp_order_details_update
GO
CREATE PROCEDURE usp_order_details_update
(
    @OrderID        int,
    @ProductID        int,
    @UnitPrice        money,
    @Quantity        smallint,
    @Discount        real
)
AS
BEGIN
    DECLARE @ErrorNumber        int
    DECLARE @ErrorSeverity        int
    DECLARE @ErrorState            int
    DECLARE @ErrorProcedure        nvarchar(128)
    DECLARE @ErrorLine            int
    DECLARE @ErrorMessage        nvarchar(4000)
    DECLARE @ErrorDate            datetime


    DECLARE @Stock            smallint
    DECLARE @Estado            bit

    DECLARE @Precio            money
    DECLARE @Cantidad          smallint

    DECLARE @strError       VARCHAR(2000)

    BEGIN TRANSACTION
    BEGIN TRY

        SELECT
            @Cantidad = [Quantity]
        FROM  [dbo].[Order Details]
        WHERE
                OrderID = @OrderID
            AND
                ProductID = @ProductID;
        SELECT
            @Precio = [UnitPrice]
            ,@Stock = [UnitsInStock]
            ,@Estado = [Discontinued]
        FROM [dbo].[Products]
        WHERE ProductID = @ProductID

        IF @UnitPrice*(1 - @Discount) < @Precio
        BEGIN
            SET @strError = CONCAT(@UnitPrice*(1-@Discount), ' debe ser >= a ', @Precio);
            THROW 50001, @strError, 1
        END
        IF @Discount > 0.2
        BEGIN
            SET @strError = 'El descuento no puede ser mayor al 20 %%';
            THROW 50002, @strError, 1
        END
        IF @Estado != 0
        BEGIN
            SET @strError = 'No puedes vender este producto porque está descontinuado';
            THROW 50003, @strError, 1
        END
        IF @Quantity > @Stock + @Cantidad
        BEGIN
            SET @strError = CONCAT('Solo tenemos en ', @Stock + @Cantidad, ' unidades de ', @Quantity,'en stock');
            THROW 50004, @strError, 1
        END

        UPDATE [dbo].[Order Details]
        SET
            [UnitPrice] = @UnitPrice
            ,[Quantity] = @Quantity
            ,[Discount] = @Discount
        WHERE
                OrderID = @OrderID
            AND
                ProductID = @ProductID

        UPDATE [dbo].[Products]
        SET [UnitsInStock] += @Cantidad - @Quantity
        WHERE [ProductID] = @ProductID;

        COMMIT TRANSACTION;
        RETURN 0
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0
        BEGIN
            SELECT
                @ErrorNumber = ERROR_NUMBER(),
                @ErrorSeverity = ERROR_SEVERITY(),
                @ErrorState = ERROR_STATE(),
                @ErrorProcedure = ERROR_PROCEDURE(),
                @ErrorLine = ERROR_LINE(),
                @ErrorMessage = ERROR_MESSAGE(),
                @ErrorDate = GETDATE()

            ROLLBACK TRANSACTION;

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
                @ErrorNumber,
                @ErrorSeverity,
                @ErrorState,
                @ErrorProcedure,
                @ErrorLine,
                @ErrorMessage,
                @ErrorDate
            )
            RETURN -1
        END
    END CATCH

END