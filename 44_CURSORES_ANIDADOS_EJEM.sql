/*
Ejemplo de un cursor anidado
*/

USE Northwind
GO

-----------------------------------------------------------
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_pedido'
)
DROP PROCEDURE usp_pedido;
GO

-----------------------------------------------------------
CREATE PROCEDURE usp_pedido
(
    @OrderID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderDate                  datetime;
    DECLARE @RequiredDate               datetime;
    DECLARE @ShippedDate                datetime;
    DECLARE @Freight                    money;
    DECLARE @ShipVia                    int;
    DECLARE @ShipName                   nvarchar(40);
    DECLARE @ShipAddress                nvarchar(60);
    DECLARE @ShipCity                   nvarchar(15);
    DECLARE @ShipRegion                 nvarchar(15);
    DECLARE @ShipPostalCode             nvarchar(10);
    DECLARE @ShipCountry                nvarchar(15);
    DECLARE @CustomerID                 nchar(5);
    DECLARE @CompanyName                nvarchar(40);
    DECLARE @Address                    nvarchar(60);
    DECLARE @Country                    nvarchar(15);

    DECLARE @ProductID                    int;
    DECLARE @ProductName                nvarchar(40);
    DECLARE @UnitPrice                    money;
    DECLARE @Quantity                    smallint;
    DECLARE @Discount                    real;

    DECLARE @ITEM                        int;
    DECLARE @Total                        money;

    DECLARE ucr_pedido CURSOR
    FOR
    SELECT
        o.[OrderID]
        ,o.[OrderDate]
        ,o.[RequiredDate]
        ,o.[ShippedDate]
        ,o.[Freight]
        ,o.[ShipVia]
        ,o.[ShipName]
        ,o.[ShipAddress]
        ,o.[ShipCity]
        ,o.[ShipRegion]
        ,o.[ShipPostalCode]
        ,o.[ShipCountry]
        ,c.[CustomerID]
        ,c.[CompanyName]
        ,c.[Address]
        ,c.[Country]
    FROM [Northwind].[dbo].[Orders] o
    INNER JOIN [Northwind].[dbo].[Customers] c
    ON c.CustomerID = o.CustomerID
    WHERE OrderID = @OrderID

    OPEN ucr_pedido;

    FETCH NEXT FROM ucr_pedido
    INTO
        @OrderID,
        @OrderDate,
        @RequiredDate,
        @ShippedDate,
        @Freight,
        @ShipVia,
        @ShipName,
        @ShipAddress,
        @ShipCity,
        @ShipRegion,
        @ShipPostalCode,
        @ShipCountry,
        @CustomerID,
        @CompanyName,
        @Address,
        @Country;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '';
        PRINT CONCAT(SPACE(50), 'Pedido: ', @OrderID)
        PRINT '';
        PRINT CONCAT(SPACE(41), 'Fecha de pedido: ', CONVERT(CHAR(10), @OrderDate, 103));
        PRINT CONCAT(SPACE(34), 'Fecha de requerimiento: ', CONVERT(CHAR(10), @RequiredDate, 103));
        PRINT CONCAT(SPACE(40), 'Fecha de entrega: ', CONVERT(CHAR(10), @ShippedDate, 103));
        PRINT '';
        PRINT CONCAT(SPACE(2), 'Cliente: ', @CompanyName);
        PRINT CONCAT('Dirección: ', @Address);
        PRINT CONCAT(SPACE(5), 'País: ', @Country);
        -- ###########################################
        DECLARE ucr_pedido_detalle CURSOR
        FOR
            SELECT
                p.[ProductID]
                ,p.[ProductName]
                ,od.[UnitPrice]
                ,od.[Quantity]
                ,od.[Discount]
            FROM  [dbo].[Products] p
            INNER JOIN [dbo].[Order Details] od
            ON p.ProductID = od.ProductID
            WHERE [OrderID] = @OrderID;

        OPEN ucr_pedido_detalle;

        FETCH NEXT FROM ucr_pedido_detalle
        INTO  
            @ProductID,
            @ProductName,
            @UnitPrice,
            @Quantity,
            @Discount;
        SET @ITEM = 1;

        PRINT '';
        PRINT CONCAT
                (
                    ' ID  ',
                    LEFT('PRODUCTO' + SPACE(39), 39),
                    LEFT('CANT' + SPACE(6), 6),
                    LEFT(' PRECIO' + SPACE(9), 9),
                    LEFT('DSC.' + SPACE(5), 5),
                    LEFT('MONTO' + SPACE(5), 5)
                )
        PRINT REPLICATE('─', 69);
        SET @Total = 0;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT CONCAT
                (
                    'I', RIGHT('00'+ LTRIM(@ITEM),2),SPACE(2),
                    LEFT(@ProductName+SPACE(35),35),
                    RIGHT(SPACE(8) + LTRIM(@Quantity), 8),
                    RIGHT(SPACE(8) + LTRIM(@UnitPrice), 8),
                    RIGHT(SPACE(5) + LTRIM(@UnitPrice*@Discount*100), 5),
                    RIGHT(SPACE(8) + LTRIM(CONVERT(DECIMAL(10, 2), @Quantity*@UnitPrice*(1-@Discount))), 8)
                )
            SET @Total += @Quantity*@UnitPrice*(1-@Discount);
            SET @ITEM += 1;
            FETCH NEXT FROM ucr_pedido_detalle
            INTO  
                @ProductID,
                @ProductName,
                @UnitPrice,
                @Quantity,
                @Discount;
        END
        PRINT REPLICATE('─', 69);
        PRINT CONCAT(SPACE(50), 'SUB-TOTAL S/ ', @Total)
        PRINT CONCAT(SPACE(54), 'IGV(18%) ', CONVERT(DECIMAL(9, 2), @Total*18.0/100))
        PRINT CONCAT(SPACE(54), 'TOTAL S/ ', CONVERT(DECIMAL(9, 2), @Total + @Total*18.0/100))

        DECLARE @strMonto VARCHAR(200) = (SELECT dbo.ufn_num_pal(@Total + @Total*18.0/100));

        PRINT 'SON: ' + @strMonto

        CLOSE ucr_pedido_detalle;
        DEALLOCATE ucr_pedido_detalle;



        -- ###########################################
        FETCH NEXT FROM ucr_pedido
        INTO
            @OrderID,
            @OrderDate,
            @RequiredDate,
            @ShippedDate,
            @Freight,
            @ShipVia,
            @ShipName,
            @ShipAddress,
            @ShipCity,
            @ShipRegion,
            @ShipPostalCode,
            @ShipCountry,
            @CustomerID,
            @CompanyName,
            @Address,
            @Country;
    END
    CLOSE ucr_pedido;
    DEALLOCATE ucr_pedido;
END
GO

-----------------------------------------------------------
EXECUTE usp_pedido 10248
GO