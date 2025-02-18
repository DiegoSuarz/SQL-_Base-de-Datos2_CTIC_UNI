/*
Usando la base de datos AdventureWorks2022
Crea un procedimiento almacenado
que muestre las ventas por año.
*/

USE AdventureWorks2022
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_venta_x_year'
)
DROP PROCEDURE usp_venta_x_year
GO
----
CREATE PROCEDURE usp_venta_x_year
AS
BEGIN
    SELECT
        YEAR(h.OrderDate) AS Año,
        CONVERT
        (
            DECIMAL(12,2),
            SUM
            (
                d.OrderQty
                *
                d.UnitPrice
                *
                (
                    1
                    -
                    IIF
                    (
                        h.OrderDate>=so.StartDate
                        AND
                        h.OrderDate<=so.EndDate
                        AND
                        d.OrderQty >= so.MinQty
                        AND
                        d.OrderQty <= ISNULL(so.MaxQty, 999999)
                        ,
                        so.DiscountPct
                        ,0
                    )
                )
            )
        ) AS Ventas
    FROM Sales.SalesOrderHeader h
    INNER JOIN Sales.SalesOrderDetail d
    ON h.SalesOrderID= d.SalesOrderID
    INNER JOIN [Sales].[SpecialOfferProduct] sop
    ON d.ProductID = sop.ProductID
    INNER JOIN [Sales].[SpecialOffer] so
    ON so.SpecialOfferID = sop.SpecialOfferID
    GROUP BY YEAR(h.OrderDate)
	ORDER BY 1 DESC
END
GO

--------
EXEC usp_venta_x_year
GO
