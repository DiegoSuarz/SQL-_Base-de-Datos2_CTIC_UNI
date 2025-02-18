/*
Crear un procedimiento almacenado que permita el
ingreso de un número entero N >= 1 y N<= 3999.

El procedimiento deberá devolverlo en número romano si
el parámetro es 1. Si es 2 en palabras y si es 3 en Ingles.
*/

USE Northwind
GO
--------------------
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_num_traducir'
)
DROP PROCEDURE usp_num_traducir
GO

---------------------
CREATE PROCEDURE usp_num_traducir
(
    @num AS INT,
    @par AS INT,
    @cad AS VARCHAR(500) OUTPUT
)
AS
BEGIN
    DECLARE @m AS INT, @c AS INT, @d AS INT, @u AS INT;

    SET @m = @num/1000
    SET @num %= 1000

    SET @c = @num/100
    SET @num %= 100

    SET @d = @num/10
    SET @u = @num % 10

    IF @par = 1
    BEGIN
        SELECT
            @cad =
            CASE @m
                WHEN 1 THEN 'M'
                WHEN 2 THEN 'MM'
                WHEN 3 THEN 'MMM'
                ELSE ''
            END
        SELECT
            @cad +=
            CASE @c
                WHEN 1 THEN 'C'
                WHEN 2 THEN 'CC'
                WHEN 3 THEN 'CCC'
                WHEN 4 THEN 'CD'
                WHEN 5 THEN 'D'
                WHEN 6 THEN 'DC'
                WHEN 7 THEN 'DCC'
                WHEN 8 THEN 'DCCC'
                WHEN 9 THEN 'CM'
                ELSE ''
            END
        SELECT
            @cad +=
            CASE @d
                WHEN 1 THEN 'X'
                WHEN 2 THEN 'XX'
                WHEN 3 THEN 'XXX'
                WHEN 4 THEN 'XL'
                WHEN 5 THEN 'L'
                WHEN 6 THEN 'LX'
                WHEN 7 THEN 'LXX'
                WHEN 8 THEN 'LXXX'
                WHEN 9 THEN 'XC'
                ELSE ''
            END
        SELECT
            @cad +=
            CASE @u
                WHEN 1 THEN 'I'
                WHEN 2 THEN 'II'
                WHEN 3 THEN 'III'
                WHEN 4 THEN 'IV'
                WHEN 5 THEN 'V'
                WHEN 6 THEN 'VI'
                WHEN 7 THEN 'VII'
                WHEN 8 THEN 'VIII'
                WHEN 9 THEN 'IX'
                ELSE ''
            END
    END
    RETURN 0
END
GO


-----------------------
DECLARE @c AS VARCHAR(500);
DECLARE @p AS INT = 1
EXECUTE usp_num_traducir 3964, @p, @c OUTPUT;

IF @p = 1
    SELECT @c AS 'NÚMERO ROMANO'