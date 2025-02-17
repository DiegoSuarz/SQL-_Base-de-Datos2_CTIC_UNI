/*
PROCEDIMIENTOS ALMACENADOS TRANSACCIONALES
Un proceso almacenado transaccional en SQL Server 2022 es un conjunto de instrucciones 
SQL que se agrupan y se almacenan en la base de datos.

Estos procesos se pueden ejecutar en respuesta a una llamada desde una aplicación
o desde otro procedimiento almacenado.

La característica clave de un proceso almacenado transaccional es que puede 
manejar transacciones, lo que significa que puede asegurar la atomicidad, 
consistencia, aislamiento y durabilidad (ACID) de las operaciones que realiza.
---------------------------------------------------------------------------------------------
Los procedimientos almacenados transaccionales en SQL Server son procedimientos 
almacenados que incluyen operaciones dentro de una transacción, asegurando que todas 
las instrucciones SQL dentro de ellos se ejecuten de manera atómica. Esto significa que 
se cumplen las propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad).

🔹 Características principales:
Atomicidad: Todas las operaciones dentro de la transacción se ejecutan completamente o 
ninguna se ejecuta si ocurre un error.
Consistencia: Mantienen la integridad de los datos en la base de datos.
Aislamiento: Permiten que las transacciones concurrentes no interfieran entre sí.
Durabilidad: Los cambios realizados en una transacción confirmada se guardan permanentemente.

Ejemplo de un procedimiento almacenado transaccional:
CREATE PROCEDURE InsertarOrden 
    @ClienteID INT, 
    @ProductoID INT, 
    @Cantidad INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Insertar una nueva orden
        INSERT INTO Ordenes (ClienteID, Fecha)
        VALUES (@ClienteID, GETDATE());

        -- Obtener el ID de la orden recién insertada
        DECLARE @OrdenID INT = SCOPE_IDENTITY();

        -- Insertar los detalles de la orden
        INSERT INTO OrdenDetalles (OrdenID, ProductoID, Cantidad)
        VALUES (@OrdenID, @ProductoID, @Cantidad);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacción
        ROLLBACK TRANSACTION;
        PRINT 'Error en la transacción: ' + ERROR_MESSAGE();
    END CATCH
END;

🔹 Explicación:
BEGIN TRANSACTION; → Inicia la transacción.
BEGIN TRY ... END TRY → Ejecuta las operaciones dentro de un bloque de control de errores.
COMMIT TRANSACTION; → Si todo sale bien, confirma los cambios.
BEGIN CATCH ... END CATCH → Si ocurre un error, se ejecuta el ROLLBACK TRANSACTION para deshacer 
							cualquier cambio realizado.
ERROR_MESSAGE(); → Muestra el mensaje del error en caso de fallo.

Este tipo de procedimientos es muy útil en sistemas donde la integridad de los datos es crucial, 
como en sistemas bancarios, gestión de inventarios o e-commerce.
*/

USE Northwind
GO
-------------------------------------------------------------------
--crear tabla de errores:
IF EXISTS  -- SI EXISTE LA TABLA tbl_error_usp, ELIMINALO
(
    SELECT name
    FROM sys.tables
    WHERE name = 'tbl_error_usp'
)
DROP TABLE tbl_error_usp
GO

SELECT
   ERROR_NUMBER() AS ErrorNumber,
   ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_STATE() AS ErrorState,
    ERROR_PROCEDURE() AS ErrorProcedure,
   ERROR_LINE() AS ErrorLine,
   ERROR_MESSAGE() AS ErrorMessage,
   GETDATE() ErrorDate
INTO tbl_error_usp

-------------------------------------------------------------------
--CREACION DE PROCEDIMIENTO ALMACENADO
IF EXISTS  -- SI EXISTE EL PROCEDIMIENTO ALMACENADO, ELIMINALO
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_order_details_insert'
)
DROP PROCEDURE usp_order_details_insert
GO

------------
CREATE PROCEDURE usp_order_details_insert
(
    @OrderID			int,
    @ProductID			int,
    @UnitPrice			money,
    @Quantity			smallint,
    @Discount			real
)
AS
BEGIN
--CAPTURAR LOS ERRORES:
    DECLARE @ErrorNumber			int
    DECLARE @ErrorSeverity			int
    DECLARE @ErrorState				int
    DECLARE @ErrorProcedure			nvarchar(128)
    DECLARE @ErrorLine				int
    DECLARE @ErrorMessage			nvarchar(4000)
    DECLARE @ErrorDate				datetime

    DECLARE @Precio					money
    DECLARE @Stock					smallint
    DECLARE @Estado					bit

    DECLARE @strError			VARCHAR(2000)

    BEGIN TRANSACTION
    BEGIN TRY
        SELECT
            @Precio = [UnitPrice]
            ,@Stock = [UnitsInStock]
            ,@Estado = [Discontinued]
        FROM [dbo].[Products]
        WHERE ProductID = @ProductID

        IF @UnitPrice*(1-@Discount) < @Precio
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
        IF @Quantity > @Stock
        BEGIN
            SET @strError = CONCAT('Solo tenemos en ', @Stock, ' unidades de ', @Quantity);
            THROW 50004, @strError, 1
        END

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
            @OrderID,
            @ProductID,
            @UnitPrice,
            @Quantity,
            @Discount
        )

        UPDATE [dbo].[Products]
        SET [UnitsInStock] =[UnitsInStock] - @Quantity
        WHERE [ProductID] = @ProductID;

        COMMIT TRANSACTION; --si no hay problema se confirma la transaccion
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
				 
            ROLLBACK TRANSACTION; --si ocurre un problema se hace un rollback a la transaccion
			/*
			El comando ROLLBACK TRANSACTION en SQL Server se usa para deshacer todas 
			las modificaciones realizadas por la transacción actual. Esto significa 
			que si estabas ejecutando varias operaciones dentro de una transacción y 
			algo salió mal, puedes ejecutar ROLLBACK TRANSACTION para revertir todo y
			dejar la base de datos en su estado anterior.
			*/
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