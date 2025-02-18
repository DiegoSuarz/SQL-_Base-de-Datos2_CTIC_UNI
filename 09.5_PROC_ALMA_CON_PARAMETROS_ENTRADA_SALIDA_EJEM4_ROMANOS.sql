/*
Crear un procedimiento almacenado que permita el
ingreso de un número entero N >= 1 y N<= 3999.

El procedimiento deberá devolverlo en número romano si
el parámetro es 1. Si es 2 en palabras y si es 3 en Ingles.
*/
USE Northwind
GO

---
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_num_traducir'
)
DROP PROCEDURE usp_num_traducir
GO

---
CREATE PROCEDURE usp_num_traducir
(
    @num AS INT,
    @par AS INT,
    @cad AS VARCHAR(500) OUTPUT
)
AS
BEGIN
    DECLARE @n AS INT = @num, @m AS INT, @c AS INT, @d AS INT, @u AS INT;

    SET @m = @num/1000
    SET @num %= 1000

    SET @c = @num/100

    SET @num %= 100

    SET @d = @num/10
    SET @u = @num % 10

    IF @par = 1 AND @n >= 1 AND @n <= 3999
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
    ELSE
    IF @par = 2 AND @n >= 1 AND @n <= 9999
    BEGIN
        SELECT
            @cad =
            CASE @m
                WHEN 1 THEN 'MIL '
                WHEN 2 THEN 'DOS MIL '
                WHEN 3 THEN 'TRES MIL '
                WHEN 4 THEN 'CUATRO MIL '
                WHEN 5 THEN 'CINCO MIL '
                WHEN 6 THEN 'SEIS MIL '
                WHEN 7 THEN 'SIETE MIL '
                WHEN 8 THEN 'OCHO MIL '
                WHEN 9 THEN 'NUEVE MIL '
                ELSE ''
            END
        SELECT
            @cad +=
            CASE @c
                WHEN 1 THEN
                    CASE @d + @u
                        WHEN 0 THEN 'CIEN'
                        ELSE 'CIENTO '
                    END
                WHEN 2 THEN 'DOSCIENTOS '
                WHEN 3 THEN 'TRESCIENTOS '
                WHEN 4 THEN 'CUATROCIENTOS '
                WHEN 5 THEN 'QUINIENTOS '
                WHEN 6 THEN 'SEISCIENTOS '
                WHEN 7 THEN 'SETECIENTOS '
                WHEN 8 THEN 'OCHOCIENTOS '
                WHEN 9 THEN 'NOVECIENTOS '
                ELSE ''
            END
        SELECT
            @cad +=
            CASE @d
                WHEN 1 THEN
                    CASE @u
                        WHEN 0 THEN 'DIEZ'
                        WHEN 1 THEN 'ONCE'
                        WHEN 2 THEN 'DOCE'
                        WHEN 3 THEN 'TRECE'
                        WHEN 4 THEN 'CATORCE'
                        WHEN 5 THEN 'QUINCE'
                        WHEN 6 THEN 'DIESISÉIS'
                        WHEN 7 THEN 'DIECISIETE'
                        WHEN 8 THEN 'DIECIOCHO'
                        WHEN 9 THEN 'DIECINUEVE'
                    END
                WHEN 2 THEN
                    CASE @u
                        WHEN 0 THEN 'VEINTE'
                        WHEN 1 THEN 'VEINTIUNO'
                        WHEN 2 THEN 'VEINTIDÓS'
                        WHEN 3 THEN 'VEINTITRÉS'
                        WHEN 4 THEN 'VEINTICUATRO'
                        WHEN 5 THEN 'VEINTICINCO'
                        WHEN 6 THEN 'VEINTISÉIS'
                        WHEN 7 THEN 'VEINTISIETE'
                        WHEN 8 THEN 'VEINTIOCHO'
                        WHEN 9 THEN 'VEINTINUEVE'
                    END
                WHEN 3 THEN 'TREINTA'
                WHEN 4 THEN 'CUARENTA'
                WHEN 5 THEN 'CINCUENTA'
                WHEN 6 THEN 'SESENTA'
                WHEN 7 THEN 'SETENTA'
                WHEN 8 THEN 'OCHENTA'
                WHEN 9 THEN 'NOVENTA'
                ELSE ''
            END
        SELECT @cad +=IIF(@d >= 3 AND @d<=9 AND @u>0, ' Y ', '')
        IF @d >= 3
            SELECT
                @cad +=
                CASE @u
                    WHEN 1 THEN 'UNO'
                    WHEN 2 THEN 'DOS'
                    WHEN 3 THEN 'TRES'
                    WHEN 4 THEN 'CUATRO'
                    WHEN 5 THEN 'CINCO'
                    WHEN 6 THEN 'SEIS'
                    WHEN 7 THEN 'SIETE'
                    WHEN 8 THEN 'OCHO'
                    WHEN 9 THEN 'NUEVE'
                    ELSE ''
                END
    END
    ELSE
        SET @cad = 'Error: Ingrese el número dentro del rango establecido.'
    RETURN 0
END
GO


-----
DECLARE @c AS VARCHAR(500);
DECLARE @p AS INT = 2  -- 1 O 2
EXECUTE usp_num_traducir 3645, @p, @c OUTPUT;
IF @p = 1    SELECT @c AS 'NÚMERO ROMANO'
IF @p = 2    SELECT @c AS 'NÚMERO EN PALABRAS'