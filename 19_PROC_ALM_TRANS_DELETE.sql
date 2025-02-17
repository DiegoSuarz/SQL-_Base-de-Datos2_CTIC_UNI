--Procedimiento Almacenado de Eliminación

USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_order_details_delete'
)
DROP PROCEDURE usp_order_details_delete
GO
CREATE PROCEDURE usp_order_details_delete
(
    @OrderID        int,
    @ProductID      int
)
AS
BEGIN
    DECLARE @ErrorNumber			int
    DECLARE @ErrorSeverity			int
    DECLARE @ErrorState				int
    DECLARE @ErrorProcedure			nvarchar(128)
    DECLARE @ErrorLine				int
    DECLARE @ErrorMessage			nvarchar(4000)
    DECLARE @ErrorDate				datetime

	
    DECLARE @Cantidad				smallint

    DECLARE @strError				VARCHAR(2000)

    BEGIN TRANSACTION
    BEGIN TRY

        SELECT
            @Cantidad = [Quantity]
        FROM  [dbo].[Order Details]
        WHERE
                OrderID = @OrderID
            AND
                ProductID = @ProductID;

        IF @@ROWCOUNT = 0 --es una función en SQL Server que devuelve el número de filas afectadas por la última instrucción ejecutada. Es útil para verificar si una consulta INSERT, UPDATE, DELETE o SELECT afectó alguna fila.
        BEGIN
            SET @strError = CONCAT('La orden ', @OrderID, ' del código de producto ', @ProductID, ' no existe.');
            THROW 50005, @strError, 1
        END

        DELETE FROM [dbo].[Order Details]
        WHERE
                OrderID = @OrderID
            AND
                ProductID = @ProductID

        UPDATE [dbo].[Products]
        SET [UnitsInStock] += @Cantidad
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


