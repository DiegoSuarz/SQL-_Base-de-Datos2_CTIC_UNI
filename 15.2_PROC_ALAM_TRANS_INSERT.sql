/*
PROCEDIMIENTOS ALMACENADOS USANDO TRANSACCIONES
PROCEDIMIENTO ALMACENADO TRANSACCIONAL POR INSERCIÓN

Un procedimiento almacenado transaccional por inserción en SQL Server es un 
bloque de código SQL que permite insertar datos en una o varias tablas, 
asegurando que la operación se realice de manera segura y consistente mediante 
el uso de transacciones.

Esto significa que, si se produce un error durante la inserción, se puede
deshacer (rollback) toda la operación, manteniendo la integridad de los datos.
*/

USE NorthwindSQL
GO
IF EXISTS
(
    SELECT name
    FROM sysobjects
    WHERE
            xtype = 'UQ'
        AND
            name = 'ak_ventas_detalles_de_pedido_id_de_producto_id_de_pedido'
)
ALTER TABLE [Ventas].[Detalles de pedido]
DROP CONSTRAINT ak_ventas_detalles_de_pedido_id_de_producto_id_de_pedido
GO
ALTER TABLE [Ventas].[Detalles de pedido]
ADD CONSTRAINT ak_ventas_detalles_de_pedido_id_de_producto_id_de_pedido
UNIQUE NONCLUSTERED ([Id de producto], [Id de pedido])
GO
-----------------------
--CREACION DE TABLA DE ERRORES:
USE NorthwindSQL
GO

IF EXISTS
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
    GETDATE() AS ErrorDate
INTO tbl_error_usp;

------------------------------------------
-- PROCEDIMIENTO ALMACENADO TRANSACCIONAL
IF EXISTS
(
    SELECT *
    FROM sys.schemas s
    INNER JOIN sys.procedures p
    ON s.schema_id = p.schema_id
    WHERE
            s.name = 'Ventas'
        AND
            p.name = 'usp_ventas_detalles_de_pedido_insert'
)
DROP PROCEDURE usp_ventas_detalles_de_pedido_insert
GO

------
CREATE PROCEDURE usp_ventas_detalles_de_pedido_insert
(
    @Id_de_pedido                int
    ,@Id_de_producto            int
    ,@Cantidad                    decimal(18,4)
    ,@Precio                    money
    ,@Descuento                    float
    ,@Id_de_situacion            int
    ,@Fecha_de_asignacion        datetime
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

    DECLARE @Costo_estandar        money
    DECLARE @Precio_listado        money
    DECLARE @Suspendido            bit

    DECLARE @msgError            nvarchar(4000)

    DECLARE @Id_de_inventario    int

    DECLARE @Stock                int =
    (
        SELECT
            SUM
            (
                CONVERT
                (
                    INT,
                    CASE ti.[Tipo de transacción]
                        WHEN 1 THEN '+'
                        WHEN 2 THEN '-'
                        WHEN 3 THEN '-'
                        WHEN 4 THEN '+'
                    END + LTRIM(ti.Cantidad)
                )
            ) AS STOCK
        FROM Almacen.Productos p
        INNER JOIN Almacen.[Transacciones de inventario] ti
        ON p.Id = ti.[Id de producto]
        WHERE p.Id = @Id_de_producto
        GROUP BY p.Id
    );

    SELECT
      @Costo_estandar = [Costo estándar]
      ,@Precio_listado = [Precio listado]
      ,@Suspendido = [Suspendido]
    FROM [Almacen].[Productos]
    WHERE [Id]= @Id_de_producto;



    BEGIN TRANSACTION
        BEGIN TRY
            IF @Cantidad > @Stock
            BEGIN
                SET @msgError = CONCAT('ERROR: La cantidad solicitada ', @Cantidad, ' es mayor que el stock: ', @Stock);
                THROW 51001, @msgError, 1;
            END
            IF NOT (@Costo_estandar < @Precio*(1-@Descuento) AND @Precio*(1-@Descuento) <= @Precio_listado)
            BEGIN
                SET @msgError = CONCAT('ERROR: ', @Costo_estandar, ' < ', @Precio*(1-@Descuento), ' <=', @Precio_listado);
                THROW 51002, @msgError, 1;
            END
            IF @Suspendido != 0
            BEGIN
                SET @msgError = 'ERROR: EL PRODUCTO SE ENCUENTRA DESCONTINUADO';
                THROW 51003, @msgError, 1;
            END

            INSERT INTO [Almacen].[Transacciones de inventario]
            (
                [Tipo de transacción]
                ,[Fecha de creación de la transacción]
                ,[Fecha modificada de la transacción]
                ,[Id de producto]
                ,[Cantidad]
                ,[Id de pedido de compra]
                ,[Id de pedido de cliente]
                ,[Comentarios]
            )
            VALUES
            (
                2
                ,GETDATE()
                ,NULL
                ,@Id_de_producto
                ,@Cantidad
                ,NULL
                ,@Id_de_pedido
                ,NULL
            );

            SET @Id_de_inventario = SCOPE_IDENTITY();

            INSERT INTO [Ventas].[Detalles de pedido]
            (
                [Id de pedido]
                ,[Id de producto]
                ,[Cantidad]
                ,[Precio]
                ,[Descuento]
                ,[Id de situación]
                ,[Fecha de asignación]
                ,[Id de pedido de compra]
                ,[Id de inventario]
            )
            VALUES
            (
                @Id_de_pedido
                ,@Id_de_producto
                ,@Cantidad
                ,@Precio
                ,@Descuento
                ,@Id_de_situacion
                ,@Fecha_de_asignacion
                ,NULL
                ,@Id_de_inventario
            );
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            SELECT
                @ErrorNumber = ERROR_NUMBER(),
                @ErrorSeverity = ERROR_SEVERITY(),
                @ErrorState = ERROR_STATE(),
                @ErrorProcedure = ERROR_PROCEDURE(),
                @ErrorLine = ERROR_LINE(),
                @ErrorMessage = ERROR_MESSAGE(),
                @ErrorDate = GETDATE();

                ROLLBACK TRANSACTION

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

            RETURN -1
        END CATCH
    RETURN 0
END


------------------------------------------------------------------------------------
--CODIGO DE EJECUCION

SELECT *
FROM [Ventas].[Detalles de pedido]
WHERE [Id de pedido] = 31
GO

DECLARE @RC int
DECLARE @Id_de_pedido int = 31
DECLARE @Id_de_producto int = 14
DECLARE @Cantidad decimal(18,4) = 20
DECLARE @Precio money = 30
DECLARE @Descuento float = 25/100.0
DECLARE @Id_de_situacion int = 2
DECLARE @Fecha_de_asignacion datetime = GetDate()

-- TODO: Establezca los valores de los parámetros aquí.

EXECUTE @RC = [dbo].[usp_ventas_detalles_de_pedido_insert]
   @Id_de_pedido
  ,@Id_de_producto
  ,@Cantidad
  ,@Precio
  ,@Descuento
  ,@Id_de_situacion
  ,@Fecha_de_asignacion
GO


SELECT *
FROM [Ventas].[Detalles de pedido]
WHERE [Id de pedido] = 31
GO
