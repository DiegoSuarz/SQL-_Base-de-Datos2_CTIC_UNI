/*
Triggers por Actualización
*/

USE [NorthwindSQL]
GO
IF EXISTS
(
    SELECT *
    FROM sys.triggers
    WHERE name = 'utr_detalles_de_pedido_update'
)
DROP TRIGGER [Ventas].[utr_detalles_de_pedido_update]
GO

-- =============================================
-- Author:        Edgard Lucho
-- Create date: 10/02/2025
-- Description:    
-- =============================================
CREATE TRIGGER Ventas.utr_detalles_de_pedido_update
   ON  Ventas.[Detalles de pedido]
   AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Id_de_pedido						int
    DECLARE @Id_de_producto						int

    DECLARE @Cantidad_ins                       decimal(18,4)
    DECLARE @Precio_ins                         money
    DECLARE @Descuento_ins                      float
    DECLARE @Fecha_de_asignacion_ins            datetime

    DECLARE @Cantidad_del                       decimal(18,4)
    DECLARE @Precio_del                         money
    DECLARE @Descuento_del                      float
    DECLARE @Fecha_de_asignacion_del            datetime
    DECLARE @Id_de_inventario_del               int

    SELECT
         @Id_de_pedido = [Id de pedido]
        ,@Id_de_producto = [Id de producto]
        ,@Cantidad_del = [Cantidad]
        ,@Precio_del = [Precio]
        ,@Descuento_del = [Descuento]
        ,@Fecha_de_asignacion_del = [Fecha de asignación]
        ,@Id_de_inventario_del = [Id de inventario]
    FROM DELETED

    SELECT
        @Cantidad_ins = [Cantidad]
        ,@Precio_ins = [Precio]
        ,@Descuento_ins = [Descuento]
        ,@Fecha_de_asignacion_ins = [Fecha de asignación]
    FROM INSERTED

    DECLARE @Costo_estandar        money
    DECLARE @Precio_listado        money
    DECLARE @Suspendido            bit

    DECLARE @Stock INT =
    (
        SELECT
            SUM
            (
                CAST
                (
                    CONCAT
                    (
                        CASE ti.[Tipo de transacción]
                            WHEN 1 THEN '+'
                            WHEN 2 THEN '-'
                            WHEN 3 THEN '-'
                            WHEN 4 THEN '+'
                        END,
                        ti.Cantidad
                    )
                    AS INT
                )
            ) AS Stock
        FROM Almacen.Productos p
        INNER JOIN [Almacen].[Transacciones de inventario] ti
        ON p.Id = ti.[Id de producto]
        WHERE p.Id = @Id_de_producto
        GROUP BY
            p.Id,
            p.[Código de producto],
            p.[Nombre del producto]
        );

    SELECT
          @Costo_estandar = [Costo estándar]
          ,@Precio_listado = [Precio listado]
          ,@Suspendido = [Suspendido]
    FROM [Almacen].[Productos]
    WHERE [Id] = @Id_de_producto

    IF @Suspendido != 0
        ROLLBACK TRANSACTION

    IF @Descuento_ins > 0.1
        ROLLBACK TRANSACTION

    IF NOT (@Precio_ins*(1-@Descuento_ins) > @Costo_estandar*1.1  AND @Precio_ins*(1-@Descuento_ins) <= @Precio_listado)
        ROLLBACK TRANSACTION

    IF @Cantidad_ins > @Stock
        ROLLBACK TRANSACTION

    UPDATE [Almacen].[Transacciones de inventario]
    SET
        [Fecha modificada de la transacción] = @Fecha_de_asignacion_ins
        ,[Cantidad] = @Cantidad_ins
    WHERE [Id de transacción]  = @Id_de_inventario_del


END
GO

-------------------------------------------------------------------------------

USE [NorthwindSQL]
GO

UPDATE [Ventas].[Detalles de pedido]
   SET
      [Cantidad] = 11
      ,[Precio] = 9
      ,[Descuento] = 0.05
      ,[Fecha de asignación] = GetDate()
WHERE
        [Id de pedido] = 31
    AND
        [Id de producto] = 3

SELECT [Id]
      ,[Id de pedido]
      ,[Id de producto]
      ,[Cantidad]
      ,[Precio]
      ,[Descuento]
      ,[Id de situación]
      ,[Fecha de asignación]
      ,[Id de pedido de compra]
      ,[Id de inventario]
  FROM [Ventas].[Detalles de pedido]
WHERE [Id de pedido] = 31
GO

SELECT [Id de transacción]
      ,[Tipo de transacción]
      ,[Fecha de creación de la transacción]
      ,[Fecha modificada de la transacción]
      ,[Id de producto]
      ,[Cantidad]
      ,[Id de pedido de compra]
      ,[Id de pedido de cliente]
      ,[Comentarios]
  FROM [Almacen].[Transacciones de inventario]
WHERE [Id de transacción]=138
GO
