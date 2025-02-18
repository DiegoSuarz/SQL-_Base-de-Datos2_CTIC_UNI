USE Northwind
GO

-----------------------------------------------------
CREATE OR ALTER FUNCTION Factorial
(
    @n int
)
RETURNS int
AS
BEGIN
    RETURN IIF(@n = 0 OR @n = 1, 1, (@n * dbo.Factorial(@n-1)));
END
GO

-----------------------------------------------------
SELECT dbo.Factorial(6) AS Factorial;
GO