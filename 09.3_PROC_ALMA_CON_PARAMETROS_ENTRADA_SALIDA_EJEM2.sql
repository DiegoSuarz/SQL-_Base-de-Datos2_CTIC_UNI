/*
PROCEDIMIENTOS ALMACENADOS CON MÁS DE UN PARÁMETRO DE ENTRADA Y SALIDA
*/

/*
Desarrollar un procedimiento para calcular el promedio de un estudiante,
se sabe que son 5 notas y se promedian las 4 mejores.

También se debe determinar la condición del estudiante,
si el promedio es mayor o igual que 14 está aprobado,
caso contrario esta desaprobado.

*/
USE Northwind
GO

----
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_promedio'
)
DROP PROCEDURE usp_promedio
GO

------
CREATE PROCEDURE usp_promedio
(
    @n1 FLOAT = 0,
    @n2 FLOAT = 0,
    @n3 FLOAT = 0,
    @n4 FLOAT = 0,
    @n5 FLOAT = 0,
    @promedio FLOAT OUTPUT,
    @condicion VARCHAR(20) OUTPUT
)
AS
BEGIN
    DECLARE @menor FLOAT = @n1;

    IF @menor > @n2 SET @menor = @n2;
    IF @menor > @n3 SET @menor = @n3;
    IF @menor > @n4 SET @menor = @n4;
    IF @menor > @n5 SET @menor = @n5;

    SET @promedio = (@n1 + @n2 + @n3 + @n4 + @n5 - @menor)/4.0

    IF @promedio >= 14
        SET @condicion = 'APROBADO'
    ELSE
        SET @condicion = 'DESAPROBADO';

    RETURN 0
END
GO

-------------------
DECLARE @prom AS FLOAT
DECLARE @cond AS VARCHAR(11);
EXECUTE usp_promedio 11,12,13,14,15, @prom OUTPUT, @cond OUTPUT
SELECT @prom AS Promedio, @cond AS Condición