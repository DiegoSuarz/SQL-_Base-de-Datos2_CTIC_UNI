/*
Módulo 1: Procedimientos Almacenados
¿Qué es un procedimiento almacenado?
Un procedimiento almacenado es un conjunto de instrucciones T-SQL que se 
almacenan en la base de datos y que se pueden ejecutar de manera reutilizable.

Uso de variables en SQL Server
Declaración de Variable Simple
Puedes declarar una variable usando la palabra clave DECLARE seguida del nombre
de la variable y su tipo de datos.
*/


/*
Mostrar la cantidad de beneficiarios menores de
un año al 31/07/2004
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
SELECT @N_0 AS [NIÑOS MENORES DE UN AÑO];

------------------------------------------------------------------------------------------
/*
Mostrar la cantidad de beneficiarios menores de
un año al 31/07/2004
*/

USE pvl
GO 
DECLARE @N_01 AS INT;

SELECT @N_01 = COUNT(*)
FROM Beneficiario
WHERE CONVERT(INT,DATEDIFF(DAY, fec_nac_ben_da, '20040731')/365.256363004) = 0

SELECT @N_01 AS [NIÑOS MENORES DE UN AÑO];