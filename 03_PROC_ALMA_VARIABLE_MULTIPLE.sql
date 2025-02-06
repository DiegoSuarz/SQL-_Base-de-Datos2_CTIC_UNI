/*
Declaración de Variables Múltiples
Puedes declarar múltiples variables del mismo tipo en una sola declaración.
*/
------------------------------------------------------------------------
--CREAR VALORES ENTRE 0 .. 0.999999
SELECT RAND()

-- 0 .. 5.99999
SELECT RAND()*6

-- 1 .. 6.99999
SELECT 1 + RAND()*6

-- 1 .. 6

------------------------------------------------------------------------
SELECT CONVERT(INT, 1 + RAND()*6)
DECLARE @N1 AS INT, @N2 AS INT, @N3 AS INT;

SET @N1 = 1 + RAND()*6;
SET @N2 = 1 + RAND()*6;
SET @N3 = 1 + RAND()*6;

SELECT
    @N1 AS Dado1,
    @N2 AS Dado2,
    @N3 AS Dado3;


-------------------------------------------------------------------
--SIN AS

DECLARE @N11 INT, @N22 INT, @N33 INT;

SET @N11 = 1 + RAND()*6;
SET @N22 = 1 + RAND()*6;
SET @N33 = 1 + RAND()*6;

SELECT
    @N11 AS Dado1,
    @N22 AS Dado2,
    @N33 AS Dado3;


