/*
Funci�n Factorial Recursiva
Una funci�n recursiva es una funci�n que se llama a s� misma dentro
de su propia definici�n.

Este tipo de funciones son �tiles para resolver problemas que pueden
descomponerse en subproblemas m�s peque�os y similares al problema original.

La recursividad es un concepto fundamental en programaci�n y matem�ticas,
y permite escribir soluciones elegantes y compactas para ciertos tipos de 
problemas.

Elementos Clave de una Funci�n Recursiva
	Caso Base: Es la condici�n que detiene la recursi�n. Sin un caso base 
		adecuado, la funci�n seguir�a llam�ndose indefinidamente, lo que 
		provocar�a un desbordamiento de pila (stack overflow).
	Caso Recursivo: Es la parte de la funci�n donde se realiza la llamada 
		recursiva, es decir, donde la funci�n se llama a s� misma con un 
		subproblema m�s peque�o.

	Descomposici�n del Problema: Cada llamada recursiva debe reducir el 
		tama�o del problema hasta que eventualmente alcance el caso base.
*/

/*
Crear la funci�n factorial utilizando recursividad

N! = N * (N-1)!

*/
USE Northwind
GO
------
CREATE OR ALTER FUNCTION ufn_factorial
(
    @n INT
)
RETURNS INT
AS
BEGIN
    IF @n <= 1 RETURN 1
    RETURN @n * dbo.ufn_factorial(@n-1)
END
GO

----------------------------------------------------------
SELECT dbo.ufn_factorial(0) AS [Factoria de 0]
SELECT dbo.ufn_factorial(1) AS [Factoria de 1]
SELECT dbo.ufn_factorial(2) AS [Factoria de 2]
SELECT dbo.ufn_factorial(3) AS [Factoria de 3]
SELECT dbo.ufn_factorial(4) AS [Factoria de 4]

----------------------------------------------------------
DECLARE @i INT = 0;
WHILE @i <= 10
BEGIN
    PRINT CONCAT(RIGHT('   ' + LTRIM(@i), 3), '! = ', dbo.ufn_factorial(@i))
    SET @i+=1;
END
GO