/*
    Desarrollar un procedimiento almacenado que permita mostrar
    la tabla de multiplicar de un número N.

    El valor de N se debe ingresar como un parámetro de entrada.
*/
USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_tabla_multiplicar'
)
DROP PROCEDURE usp_tabla_multiplicar
GO
------
CREATE PROCEDURE usp_tabla_multiplicar
(
    @n INT
)
AS
BEGIN
    DECLARE @cnt INT = 0;
    IF @n >= 0 AND @n <= 12
    BEGIN
        WHILE @cnt <= 12
        BEGIN

            PRINT CONCAT(@n, '*', @cnt, '=', @n * @cnt);
            SET @cnt += 1;
        END
        RETURN 0 --RETURN DE WHILE
    END
    ELSE
    BEGIN
        RETURN -1 --SI HAY UN ERROR DEVUELVE -1 , REGURN DEL IF
    END
END
GO

---------------------------------
usp_tabla_multiplicar 4
GO

---------------------------------
usp_tabla_multiplicar 12
GO