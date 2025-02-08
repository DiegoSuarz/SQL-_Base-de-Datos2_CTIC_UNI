/*
Función Suma Dinámica
*/

USE Northwind
GO
-----------------
CREATE OR ALTER Function Suma
(
    @lista        VARCHAR(8000)
)
RETURNS INT
AS
BEGIN
    DECLARE @numero INT
    DECLARE @s INT = 0
    DECLARE @pos INT = CHARINDEX(',', @lista)

    IF @pos>0
    BEGIN
        SET @numero = CAST(SUBSTRING(@lista, 1,  CHARINDEX(',', @lista)-1) AS INT);
        SET @s += @numero
    END
    ELSE
    BEGIN
        SET @numero = CAST(@lista AS INT)
        SET @s += @numero
        RETURN @s;
    END

    SET @lista = SUBSTRING(@lista, CHARINDEX(',', @lista) + 1, LEN(@lista))
    RETURN @s + dbo.Suma(@lista)

END
GO

----------------------------------------------------
SELECT dbo.Suma('')
SELECT dbo.Suma('0')
SELECT dbo.Suma('1,2,3')

-----------------------------------------------------------------------------

CREATE OR ALTER FUNCTION dbo.Suma
(
    @lista VARCHAR(8000)
)
RETURNS INT
AS
BEGIN
    RETURN IIF(@lista = '', 0,
               IIF(CHARINDEX(',', @lista) > 0,
                   CAST(SUBSTRING(@lista, 1, CHARINDEX(',', @lista) - 1) AS INT) + dbo.Suma(SUBSTRING(@lista, CHARINDEX(',', @lista) + 1, LEN(@lista))),
                   CAST(@lista AS INT)));
END
GO

-- Ejemplo de uso:
SELECT dbo.Suma('0,1,2,3');  -- Resultado: 6
SELECT dbo.Suma('');         -- Resultado: 0