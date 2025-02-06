/*
Procedimientos Almacenados con un parámetro


Sentencia de control IF
La sentencia de control IF en SQL Server 2022 se utiliza para ejecutar una instrucción
o un bloque de instrucciones condicionalmente, dependiendo de si una condición específica 
se evalúa como verdadera o falsa.

Esta estructura es útil para implementar lógica de control en tus scripts SQL, como en 
procedimientos almacenados o scripts de mantenimiento.


--Sintaxis 1

IF (Condición)
  -- Sentencia a ejecutarse si la condición es verdadera
ELSE
  -- Sentencia a ejecutarse si la condición es falsa+


--Sintaxis 2
IF (Condición)
BEGIN
  -- Sentencia 1 a ejecutarse si la condición es verdadera
  -- Sentencia 2 a ejecutarse si la condición es verdadera
  -- ...
  -- Sentencia N a ejecutarse si la condición es verdadera
END
ELSE
BEGIN
  -- Sentencia 1 a ejecutarse si la condición es falsa
  -- Sentencia 2 a ejecutarse si la condición es falsa
  -- ...
  -- Sentencia N a ejecutarse si la condición es falsa
END
*/

USE pvl
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_beneficiario_consulta'
)
DROP PROCEDURE usp_beneficiario_consulta
GO

--
CREATE PROCEDURE usp_beneficiario_consulta
(
    @parametro AS VARCHAR(115) = NULL --variable , NULL si no envia nada
)
AS
BEGIN
    IF @parametro IS NULL --si el parametro es nulo
        SELECT TOP 10
            cod_ben_in AS [Código del beneficiario],
            (
                SELECT Comité = CONCAT(nom_cen_aco_vc, ' - ' ,nom_pue_vc, ' - ' , nom_com_vc)
                FROM CentroAcopio ca
                INNER JOIN Pueblo p
                ON ca.cod_cen_aco_ti = p.cod_cen_aco_ti
                INNER JOIN Comite c
                ON p.cod_pue_si = c.cod_pue_si
                WHERE cod_com_si = b.cod_com_si
            ) AS Comité,
            pat_ben_vc AS Paterno,
            mat_ben_vc AS Materno,
            nom_ben_vc AS Nombres,
            dni_ben_ch AS DNI,
            CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [Fecha de Nacimiento],
            CONVERT(INT, DATEDIFF(DAY, fec_nac_ben_da, '20040731') / 365.256363004) AS Edad,
            IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS Sexo
        FROM Beneficiario b
    ELSE
    IF ISNUMERIC(@parametro) = 1 AND @parametro NOT LIKE ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
        SELECT TOP 50
            cod_ben_in AS [Código del beneficiario],
            (
                SELECT Comité = CONCAT(nom_cen_aco_vc, ' - ' ,nom_pue_vc, ' - ' , nom_com_vc)
                FROM CentroAcopio ca
                INNER JOIN Pueblo p
                ON ca.cod_cen_aco_ti = p.cod_cen_aco_ti
                INNER JOIN Comite c
                ON p.cod_pue_si = c.cod_pue_si
                WHERE cod_com_si = b.cod_com_si
            ) AS Comité,
            pat_ben_vc AS Paterno,
            mat_ben_vc AS Materno,
            nom_ben_vc AS Nombres,
            dni_ben_ch AS DNI,
            CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [Fecha de Nacimiento],
            CONVERT(INT, DATEDIFF(DAY, fec_nac_ben_da, '20040731') / 365.256363004) AS Edad,
            IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS Sexo
        FROM Beneficiario b
        WHERE cod_ben_in = @parametro
    ELSE
    IF @parametro LIKE ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
        SELECT
            cod_ben_in AS [Código del beneficiario],
            (
                SELECT Comité = CONCAT(nom_cen_aco_vc, ' - ' ,nom_pue_vc, ' - ' , nom_com_vc)
                FROM CentroAcopio ca
                INNER JOIN Pueblo p
                ON ca.cod_cen_aco_ti = p.cod_cen_aco_ti
                INNER JOIN Comite c
                ON p.cod_pue_si = c.cod_pue_si
                WHERE cod_com_si = b.cod_com_si
            ) AS Comité,
            pat_ben_vc AS Paterno,
            mat_ben_vc AS Materno,
            nom_ben_vc AS Nombres,
            dni_ben_ch AS DNI,
            CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [Fecha de Nacimiento],
            CONVERT(INT, DATEDIFF(DAY, fec_nac_ben_da, '20040731') / 365.256363004) AS Edad,
            IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS Sexo
        FROM Beneficiario b
        WHERE dni_ben_ch = @parametro
    ELSE
    IF @parametro LIKE ('[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]') AND ISDATE(@parametro) = 1
        SELECT
            cod_ben_in AS [Código del beneficiario],
            (
                SELECT Comité = CONCAT(nom_cen_aco_vc, ' - ' ,nom_pue_vc, ' - ' , nom_com_vc)
                FROM CentroAcopio ca
                INNER JOIN Pueblo p
                ON ca.cod_cen_aco_ti = p.cod_cen_aco_ti
                INNER JOIN Comite c
                ON p.cod_pue_si = c.cod_pue_si
                WHERE cod_com_si = b.cod_com_si
            ) AS Comité,
            pat_ben_vc AS Paterno,
            mat_ben_vc AS Materno,
            nom_ben_vc AS Nombres,
            dni_ben_ch AS DNI,
            CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [Fecha de Nacimiento],
            CONVERT(INT, DATEDIFF(DAY, fec_nac_ben_da, '20040731') / 365.256363004) AS Edad,
            IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS Sexo
        FROM Beneficiario b
        WHERE fec_nac_ben_da = CONVERT(DATE, @parametro, 103) --filtrar por fecha de nacimiento
    ELSE
        SELECT
            cod_ben_in AS [Código del beneficiario],
            (
                SELECT Comité = CONCAT(nom_cen_aco_vc, ' - ' ,nom_pue_vc, ' - ' , nom_com_vc)
                FROM CentroAcopio ca
                INNER JOIN Pueblo p
                ON ca.cod_cen_aco_ti = p.cod_cen_aco_ti
                INNER JOIN Comite c
                ON p.cod_pue_si = c.cod_pue_si
                WHERE cod_com_si = b.cod_com_si
            ) AS Comité,
            pat_ben_vc AS Paterno,
            mat_ben_vc AS Materno,
            nom_ben_vc AS Nombres,
            dni_ben_ch AS DNI,
            CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [Fecha de Nacimiento],
            CONVERT(INT, DATEDIFF(DAY, fec_nac_ben_da, '20040731') / 365.256363004) AS Edad,
            IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS Sexo
        FROM Beneficiario b
        WHERE CONCAT(pat_ben_vc, SPACE(1), mat_ben_vc, SPACE(1), nom_ben_vc) LIKE @parametro + '%' --filtrar por nombre de beneficiario
    RETURN 0;
END
GO

------- sin parametro muestra top 10
usp_beneficiario_consulta 
GO

------ el numero del codigo de beneficiario:
usp_beneficiario_consulta 9
GO

--- buscar por DNI:
usp_beneficiario_consulta '07066071'
GO

--- buscar por fecha de nacimiento:
usp_beneficiario_consulta '02/03/1932'
GO

--- buscar por nombre:
usp_beneficiario_consulta 'quispe'
GO

usp_beneficiario_consulta 'quispe quispe'
GO

usp_beneficiario_consulta 'quispe quispe m'
GO

usp_beneficiario_consulta 'quispe quispe martinina'
GO

