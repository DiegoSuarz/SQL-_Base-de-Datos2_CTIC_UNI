/*
Usando la base de datos AdventureWorksDQ2022
Crea un procedimiento almacenado
que muestre las ventas por año.
*/

USE AdventureWorksDW2022
GO

IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_venta_x_year'
)
DROP PROCEDURE usp_venta_x_year
GO
---
CREATE PROCEDURE usp_venta_x_year
AS
BEGIN
    SELECT
        YEAR(f.OrderDate) AS Año,
        CONVERT
        (
            DECIMAL(12,2),
            SUM
            (
                f.OrderQuantity
                *
                (
                    1
                    -
                    IIF
                    (
                        f.OrderDate>=p.StartDate
                        AND
                        f.OrderDate<=p.EndDate
                        AND
                        f.OrderQuantity >= p.MinQty
                        AND
                        f.OrderQuantity <= ISNULL(p.MaxQty, 999999)
                        ,
                        p.DiscountPct
                        ,0
                    )
                )
            )
        ) AS Ventas
    FROM DimPromotion p
    INNER JOIN FactInternetSales f
    ON f.PromotionKey = p.PromotionKey
    GROUP BY YEAR(f.OrderDate)

    RETURN 0
END
GO

----
DECLARE @Error INT;
EXEC @Error = usp_venta_x_year;

SELECT @Error AS Error