USE [NorthwindSQL]
GO
IF EXISTS
(
    SELECT *
    FROM sys.triggers
    WHERE name = 'utr_detalles_de_pedido_delete'
)
DROP TRIGGER [Ventas].[utr_detalles_de_pedido_delete]
GO

-- =============================================
-- Author:        Edgard Lucho
-- Create date: 10/02/2025
-- Description:
-- =============================================

CREATE TRIGGER Ventas.utr_detalles_de_pedido_delete
   ON  Ventas.[Detalles de pedido]
   AFTER DELETE --LANZA UN TRIGGER DESPUES DE ELIMINAR UN ELEMENTO DE LA TABLA Ventas.[Detalles de pedido]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Id_de_pedido                int
    DECLARE @Id_de_producto              int
    DECLARE @Cantidad                    decimal(18,4)
    DECLARE @Precio                      money
    DECLARE @Descuento                   float
    DECLARE @Fecha_de_asignacion		 datetime

    SELECT
         @Id_de_pedido = [Id de pedido]
        ,@Id_de_producto = [Id de producto]
        ,@Cantidad = [Cantidad]
    FROM DELETED --TABLA VIRTUAL DE ELIMINACION DEL TRIGGER

    IF @@ROWCOUNT = 1   --@@ROWCOUNT es una funci�n en SQL Server que devuelve el n�mero de filas afectadas por la �ltima consulta ejecutada en la sesi�n actual.
	    INSERT INTO [Almacen].[Transacciones de inventario]
        (
            [Tipo de transacci�n]
            ,[Fecha de creaci�n de la transacci�n]
            ,[Fecha modificada de la transacci�n]
            ,[Id de producto]
            ,[Cantidad]
            ,[Id de pedido de compra]
            ,[Id de pedido de cliente]
            ,[Comentarios]
        )
        VALUES
        (
            4
            ,GetDate()
            ,NULL
            ,@Id_de_producto
            ,@Cantidad
            ,NULL
            ,@Id_de_pedido
            ,NULL
        )

END
GO



-------------------------------------------------------------------------------
--CODIGO DE PRUEBA:

USE [NorthwindSQL]
GO
DECLARE @Id_de_pedido    INT = 31;
DECLARE @Id                INT = 3;

SELECT *
FROM Almacen.Productos
WHERE Id = @Id;

SELECT * FROM [Ventas].[Detalles de pedido]
WHERE [Id de pedido] = @Id_de_pedido;

SELECT
    [Id de transacci�n]
    ,[Tipo de transacci�n]
    ,[Fecha de creaci�n de la transacci�n]
    ,[Fecha modificada de la transacci�n]
    ,[Id de producto]
    ,[Cantidad]
    ,[Id de pedido de compra]
    ,[Id de pedido de cliente]
    ,[Comentarios]
FROM [Almacen].[Transacciones de inventario];

DELETE FROM [Ventas].[Detalles de pedido]
WHERE
        [Id de pedido] = 31
    AND
        [Id de producto] = 3


SELECT *
FROM Almacen.Productos
WHERE Id = @Id;


SELECT * FROM [Ventas].[Detalles de pedido]
WHERE [Id de pedido] = @Id_de_pedido;


SELECT
    [Id de transacci�n]
    ,[Tipo de transacci�n]
    ,[Fecha de creaci�n de la transacci�n]
    ,[Fecha modificada de la transacci�n]
    ,[Id de producto]
    ,[Cantidad]
    ,[Id de pedido de compra]
    ,[Id de pedido de cliente]
    ,[Comentarios]
FROM [Almacen].[Transacciones de inventario];