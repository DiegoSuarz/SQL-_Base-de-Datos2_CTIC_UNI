/*
Procedimientos Almacenados con parámetros de Entrada 
y parámetros de Salida
*/

/*
    Crear un procedimiento almacenedado que permita ingresar un número entero
    entre 1 y 3999 y descomponga en millares, centenas, decenas, unidades.
*/
USE Northwind
GO

IF EXISTS --existe el procedimiento almacenado usp_num_rom
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_num_rom'
)
DROP PROCEDURE usp_num_rom
GO
--------------------
CREATE PROCEDURE usp_num_rom
(
    @n INT --crear variable
)
AS
BEGIN
    DECLARE  @m INT   --variabla millares
    DECLARE  @c INT		--variable centenas
    DECLARE  @d INT		--variable decenas
    DECLARE  @u INT		--variable unidades

    PRINT CONCAT('N:', @n)

    SET @m = @n / 1000; --division entera
    SET @n %= 1000;  --residuo
    PRINT CONCAT('M:', @m)
    PRINT CONCAT('N:', @n)

    SET @c = @n / 100;	--centenas
    SET @n %= 100;		

    PRINT CONCAT('C:', @c)
    PRINT CONCAT('N:', @n)

    SET @d = @n / 10;	--decenas
    SET @u = @n % 10;	--unidades

    PRINT CONCAT('D:', @d)
    PRINT CONCAT('U:', @u)
    PRINT CONCAT('N:', @n)


    RETURN 0
END
GO

-----------------------
EXECUTE usp_num_rom 1234
GO
-----------------------
EXEC usp_num_rom 1234
GO
-----------------------
usp_num_rom 1234
GO