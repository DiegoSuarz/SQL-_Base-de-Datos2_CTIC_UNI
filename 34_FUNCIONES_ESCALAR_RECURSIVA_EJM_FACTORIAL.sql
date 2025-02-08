
CREATE OR ALTER FUNCTION dbo.Factorial
(
    @n INT
)
RETURNS INT
AS
BEGIN
    RETURN IIF(@n = 0, 1, @n * dbo.Factorial(@n - 1));
END
GO
------------------------------------------------
DECLARE @i INT = 0;
WHILE @i <= 10
BEGIN
    PRINT CONCAT(RIGHT('   ' + LTRIM(@i), 3), '! = ', dbo.ufn_factorial(@i))
    SET @i+=1;
END
GO