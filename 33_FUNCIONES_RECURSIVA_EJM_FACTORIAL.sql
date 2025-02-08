/*
Función Factorial Recursiva
Una función recursiva es una función que se llama a sí misma dentro
de su propia definición.

Este tipo de funciones son útiles para resolver problemas que pueden
descomponerse en subproblemas más pequeños y similares al problema original.

La recursividad es un concepto fundamental en programación y matemáticas,
y permite escribir soluciones elegantes y compactas para ciertos tipos de 
problemas.

Elementos Clave de una Función Recursiva
	Caso Base: Es la condición que detiene la recursión. Sin un caso base 
		adecuado, la función seguiría llamándose indefinidamente, lo que 
		provocaría un desbordamiento de pila (stack overflow).
	Caso Recursivo: Es la parte de la función donde se realiza la llamada 
		recursiva, es decir, donde la función se llama a sí misma con un 
		subproblema más pequeño.

	Descomposición del Problema: Cada llamada recursiva debe reducir el 
		tamaño del problema hasta que eventualmente alcance el caso base.
*/

/*
Crear la función factorial utilizando recursividad

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