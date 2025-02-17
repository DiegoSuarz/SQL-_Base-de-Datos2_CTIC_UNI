/*
MÓDULO 5: TRIGGERS
¿Qué es un Trigger?
Un trigger es un objeto de base de datos que se ejecuta
automáticamente en respuesta a ciertos eventos en una
tabla o vista.

Los triggers son útiles para mantener la integridad de los 
datos y para realizar acciones automatizadas cuando ocurren 
cambios en la base de datos.

Tipos de Triggers
	AFTER Triggers: Se ejecutan después de que se ha realizado 
					la operación de modificación de datos
					(INSERT, UPDATE, DELETE). Son útiles para
					realizar acciones que dependen de que la operación
					original haya tenido éxito.

	INSTEAD OF Triggers: Se ejecutan en lugar de la operación que los activa.
							Son útiles, por ejemplo, para realizar operaciones 
							complejas o para manejar vistas.

	DML Triggers: Se activan por las operaciones de Manipulación de Datos (DML)
					como INSERT, UPDATE y DELETE.

Diferencias entre Triggers y Procedimientos Almacenados

Triggers: Son objetos que se ejecutan automáticamente en respuesta a eventos 
		específicos en la base de datos, como INSERT, UPDATE o DELETE.
		Se utilizan principalmente para mantener la integridad de los datos
		y realizar acciones automatizadas. Se ejecutan automáticamente y no se
		pueden invocar directamente. Su ejecución ocurre como parte de la
		transacción que activa el evento.

Procedimientos Almacenados: Son conjuntos de instrucciones SQL que se pueden 
			ejecutar de manera explícita cuando se invocan. Se utilizan para 
			 encapsular lógica de negocio, realizar operaciones complejas y 
			 mejorar la reutilización de código. Se ejecutan de forma manual
			 mediante una llamada explícita desde aplicaciones o desde scripts 
			 SQL.

Casos de uso comunes de triggers

Auditoría de Cambios: Los triggers pueden registrar automáticamente cambios 
					en los datos. Por ejemplo, cada vez que un registro se 
					inserta, actualiza o elimina, se puede crear un registro 
					en una tabla de auditoría que contenga detalles sobre la 
					operación, como quién la realizó y cuándo.
Validación de Datos: Se pueden utilizar para validar datos antes de que se 
					inserten o actualicen. Por ejemplo, un trigger puede 
					verificar que ciertos campos no sean nulos o que cumplan
					con un formato específico.
Mantenimiento de Integridad Referencial: Aunque las claves foráneas suelen manejar
					la integridad referencial, los triggers pueden usarse para
					implementar reglas de negocio más complejas, como la 
					eliminación de registros relacionados en caso de que un 
					registro padre se elimine.
Cálculos Automáticos: Se pueden usar para realizar cálculos automáticos. Por 
					ejemplo, al insertar o actualizar un registro en una tabla 
					de ventas, un trigger puede calcular el total de la venta 
					y actualizar un campo correspondiente.
Notificaciones Automáticas: Los triggers pueden enviar notificaciones automáticas
					mediante el uso de procedimientos almacenados o servicios 
					externos. Por ejemplo, se puede enviar un correo electrónico
					cuando se inserta un nuevo registro en una tabla de pedidos.
Control de Acceso: Aunque la seguridad se maneja principalmente a través de
					permisos, los triggers pueden ayudar a implementar controles 
					adicionales, como restringir ciertas operaciones basadas en
					condiciones específicas.
Sincronización de Datos: Se pueden usar para mantener sincronizados datos entre 
					diferentes tablas o bases de datos. Por ejemplo, al actualizar
					un registro en una tabla, un trigger puede actualizar 
					automáticamente un registro en otra tabla relacionada.
Historial de Cambios: Se pueden utilizar para mantener un historial de cambios en
					un registro. Un trigger puede copiar los datos antiguos a 
					otra tabla antes de que se realice una actualización.
*/

/*
Triggers por Inserción (INSERT)
*/
USE [NorthwindSQL]
GO
IF EXISTS
(
    SELECT *
    FROM sys.triggers
    WHERE name = 'utr_detalles_de_pedido_insert'
)
DROP TRIGGER [Ventas].[utr_detalles_de_pedido_insert]
GO

-- =============================================
-- Author:        Edgard Lucho
-- Create date: 10/02/2025
-- Description:    
-- =============================================
CREATE TRIGGER Ventas.utr_detalles_de_pedido_insert
   ON  Ventas.[Detalles de pedido]
   AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Id_de_pedido				int
    DECLARE @Id_de_producto				int
    DECLARE @Cantidad                   decimal(18,4)
    DECLARE @Precio                     money
    DECLARE @Descuento                  float
    DECLARE @Fecha_de_asignacion        datetime

    SELECT
         @Id_de_pedido = [Id de pedido]
        ,@Id_de_producto = [Id de producto]
        ,@Cantidad = [Cantidad]
        ,@Precio = [Precio]
        ,@Descuento = [Descuento]
        ,@Fecha_de_asignacion = [Fecha de asignación]
    FROM INSERTED --Es una tabla virtual que SQL Server proporciona dentro de los triggers para almacenar los valores nuevos insertados en una tabla específica.

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
        )
    SELECT
          @Costo_estandar = [Costo estándar]
          ,@Precio_listado = [Precio listado]
          ,@Suspendido = [Suspendido]
    FROM [Almacen].[Productos]
    WHERE [Id] = @Id_de_producto

    IF @Suspendido != 0  --SI EL PEDIDO ESTA SUSPENDIDO
        ROLLBACK TRANSACTION

    IF @Descuento > 0.1
        ROLLBACK TRANSACTION

    IF NOT (@Precio*(1-@Descuento) > @Costo_estandar*1.1  AND @Precio*(1-@Descuento) <= @Precio_listado)
        ROLLBACK TRANSACTION

    IF @Cantidad > @Stock
        ROLLBACK TRANSACTION

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
        ,@Fecha_de_asignacion
        ,NULL
        ,@Id_de_producto
        ,@Cantidad
        ,NULL
        ,@Id_de_pedido
        ,NULL
    )

    UPDATE [Ventas].[Detalles de pedido]
    SET [Id de inventario]=SCOPE_IDENTITY() --es una función en SQL Server que devuelve el último valor de identidad (IDENTITY) generado en el mismo ámbito de ejecución.
    FROM [Ventas].[Detalles de pedido] d
    INNER JOIN INSERTED i
    ON
        d.[Id de pedido]=i.[Id de pedido]
        AND
        d.[Id de producto]=i.[Id de producto]

END
GO




------------------------------------------------------------------
--CODIGO DE PRUEBA:
USE [NorthwindSQL]
GO

DECLARE @Id_de_pedido	INT = 31; 
--DECLARE @Id				INT = 1;
DECLARE @Id				INT = 3;
---------------------------------------------
SELECT * FROM Almacen.Productos
WHERE Id = @Id;

SELECT * FROM [Ventas].[Detalles de pedido]
WHERE [Id de pedido] = @Id_de_pedido;


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
           ,@Id
           ,15
           ,10
           ,0
           ,2
           ,GETDATE()
           ,NULL
           ,NULL
	)
GO

-------------------------------------------------------------------
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


