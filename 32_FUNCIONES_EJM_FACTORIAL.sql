/*
Crear la función factorial
*/
USE Northwind
GO
---
CREATE OR ALTER FUNCTION ufn_factorial
(
    @n INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cnt INT = 1;
    DECLARE @f INT = 1;
    WHILE @cnt <= @n
    BEGIN
        SET @f *= @cnt;
        SET @cnt += 1;
    END

    RETURN @f
END
GO


---------------------------------------
SELECT dbo.ufn_factorial(0) AS Factorial
GO

---------------------------------------
SELECT dbo.ufn_factorial(2) AS Factorial
GO

---------------------------------------
SELECT dbo.ufn_factorial(3) AS Factorial
GO