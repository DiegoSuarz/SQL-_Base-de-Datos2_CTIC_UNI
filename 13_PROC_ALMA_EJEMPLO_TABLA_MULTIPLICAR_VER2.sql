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
CREATE PROCEDURE usp_tabla_multiplicar
(
    @n INT
)
AS
BEGIN
    DECLARE @cnt INT = 0;
    IF @n >= 0 AND @n <= 12
    BEGIN
        PRINT CONCAT('TABLA DE MULTIPLICAR DEL NÚMERO ', @n)
        PRINT REPLICATE('─', 34)
        WHILE @cnt <= 12
        BEGIN
            PRINT CONCAT(@n, ' * ', RIGHT(SPACE(2) + LTRIM(@cnt), 2), ' = ', RIGHT(SPACE(3) + LTRIM(@n * @cnt), 3) );
            SET @cnt += 1;
        END
        RETURN 0
    END
    ELSE
    BEGIN
        RETURN -1
    END
END
GO
usp_tabla_multiplicar 6
GO