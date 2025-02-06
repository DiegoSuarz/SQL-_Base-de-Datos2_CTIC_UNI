/*
    Crear un procedimiento almacenedado que permita ingresar un número entero
    entre 1 y 3999 y me devuelva dicho número en números romanos.
*/
USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_num_rom'
)
DROP PROCEDURE usp_num_rom
GO
CREATE PROCEDURE usp_num_rom
(
    @n INT,								--PARAMETRO DE ENTRADA
    @strRom VARCHAR(200)  = '' OUTPUT	--PARAMETRO DE SALIDA VACIO
)
AS
BEGIN
    DECLARE  @m INT
    DECLARE  @c INT
    DECLARE  @d INT
    DECLARE  @u INT

    SET @m = @n / 1000;
    SET @n %= 1000;

    SET @c = @n / 100;
    SET @n %= 100;

    SET @d = @n / 10;
    SET @u = @n % 10;

    SET @strRom =
    (
        SELECT
            CASE @m
                WHEN 1 THEN 'M'
                WHEN 2 THEN 'MM'
                WHEN 3 THEN 'MMM'
                ELSE ''
            END
    )
    SET @strRom +=
    (
        SELECT
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
    )
    SET @strRom +=
    (
        SELECT
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
    )
    SET @strRom +=
    (
        SELECT
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
    )

    RETURN 0
END
GO

---------------------------
DECLARE @rom AS VARCHAR(200);
EXECUTE usp_num_rom 1234, @rom OUTPUT
SELECT @rom AS [EN ROMANOS]
GO
---------------------------
DECLARE @rom AS VARCHAR(200);
EXECUTE usp_num_rom 1 , @rom OUTPUT
SELECT @rom AS [EN ROMANOS]
GO
---------------------------
DECLARE @rom AS VARCHAR(200);
EXECUTE usp_num_rom 12 , @rom OUTPUT
SELECT @rom AS [EN ROMANOS]
GO