/*
M�dulo 1: Procedimientos Almacenados
�Qu� es un procedimiento almacenado?
Un procedimiento almacenado es un conjunto de instrucciones T-SQL que se 
almacenan en la base de datos y que se pueden ejecutar de manera reutilizable.

Uso de variables en SQL Server
Declaraci�n de Variable Simple
Puedes declarar una variable usando la palabra clave DECLARE seguida del nombre
de la variable y su tipo de datos.
*/


/*
Mostrar la cantidad de beneficiarios menores de
un a�o al 31/07/2004
*/
USE pvl
GO 
DECLARE @N_0 AS INT; --declaracion de variable
SET @N_0 =
(
    SELECT COUNT(*)
    FROM Beneficiario
    WHERE
        CONVERT(INT,DATEDIFF(DAY, fec_nac_ben_da, '20040731')/365.256363004) = 0
);
SELECT @N_0 AS [NI�OS MENORES DE UN A�O];

------------------------------------------------------------------------------------------
/*
Mostrar la cantidad de beneficiarios menores de
un a�o al 31/07/2004
*/

USE pvl
GO 
DECLARE @N_01 AS INT;

SELECT @N_01 = COUNT(*)
FROM Beneficiario
WHERE CONVERT(INT,DATEDIFF(DAY, fec_nac_ben_da, '20040731')/365.256363004) = 0

SELECT @N_01 AS [NI�OS MENORES DE UN A�O];