USE Northwind
GO

------------------------------------------------------------
IF EXISTS
(
    SELECT name
    FROM sysobjects
    WHERE
            xtype = 'FN'
        AND
            name = 'ufn_num_pal '
)
DROP FUNCTION ufn_num_pal
GO

------------------------------------------------------------
CREATE FUNCTION ufn_num_pal
(
    @monto float
)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @pal VARCHAR(200);
    DECLARE @n        INT = CONVERT(INT, @monto);
    DECLARE @f        INT = CONVERT(INT,100.0 * (@monto - CAST(@monto AS INT))+0.00000000000001);

    DECLARE @m        INT;
    DECLARE @c        INT;
    DECLARE @d        INT;
    DECLARE @u        INT;

    SET @m = @n / 1000;
    SET @n -= @m * 1000;

    SET @c = @n / 100;
    SET @n -= @c * 100;

    SET @d = @n / 10;
    SET @u = @n - @d * 10;

    SET @pal =
    (
        SELECT
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
    )
    SET @pal +=
    (
        SELECT
            CASE @c
                WHEN 1 THEN IIF(@d+@u = 0, 'CIEN', 'CIENTO ')
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
    )

    SET @pal +=
    (
        SELECT
            CASE @d
                WHEN 1 THEN
                    CASE @u
                        WHEN 0 THEN 'DIEZ'
                        WHEN 1 THEN 'ONCE'
                        WHEN 2 THEN 'DOCE'
                        WHEN 3 THEN 'TRECE'
                        WHEN 4 THEN 'CATORCE'
                        WHEN 5 THEN 'QUINCE'
                        WHEN 6 THEN 'DIECISÉIS'
                        WHEN 7 THEN 'DIESISIETE'
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
    )
    SET @pal += IIF(@d >= 3 AND @u != 0, ' Y ', '')
    IF @d != 1 AND @d!=2
    SET @pal +=
    (
        SELECT
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
    )


    SET @pal = CONCAT(@pal, ' CON ', @f, '/100 SOLES ')

    RETURN @pal

END
GO

------------------------------------------------------------
SELECT dbo.ufn_num_pal(1.20)
GO