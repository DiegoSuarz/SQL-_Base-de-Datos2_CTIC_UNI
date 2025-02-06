/*
Declaración de Variable y Asignación

Mostrar la cantidad de beneficiarios menores de
un año al 31/07/2004
*/
DECLARE @N_0 AS INT = 4
(
    SELECT COUNT(*)
    FROM Beneficiario
    WHERE
        CONVERT(INT,DATEDIFF(DAY, fec_nac_ben_da, '20040731')/365.256363004) = 0
);
SELECT @N_0 AS [NIÑOS MENORES DE UN AÑO];