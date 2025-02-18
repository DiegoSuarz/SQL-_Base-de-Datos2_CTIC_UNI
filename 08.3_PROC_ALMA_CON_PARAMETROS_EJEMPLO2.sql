USE PVL
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_beneficiario_consulta'
)
DROP PROCEDURE usp_beneficiario_consulta
GO

----
CREATE PROCEDURE usp_beneficiario_consulta
(
    @parametro AS VARCHAR(115) = NULL
)
AS
BEGIN
    IF @parametro IS NULL
        SELECT TOP 20
            cod_ben_in AS CÓDIGO,
            pat_ben_vc AS PATERNO,
            mat_ben_vc AS MATERNO,
            nom_ben_vc AS NOMBRE,
            CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [FECHA DE NACIMIENTO],
            dni_ben_ch AS DNI,
            IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS SEXO
        FROM Beneficiario
    ELSE
        IF ISNUMERIC(@parametro)=1 AND @parametro NOT LIKE ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
            SELECT
                cod_ben_in AS CÓDIGO,
                pat_ben_vc AS PATERNO,
                mat_ben_vc AS MATERNO,
                nom_ben_vc AS NOMBRE,
                CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [FECHA DE NACIMIENTO],
                dni_ben_ch AS DNI,
                IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS SEXO
            FROM Beneficiario
            WHERE cod_ben_in = @parametro
        ELSE
            IF @parametro LIKE ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
                SELECT
                    cod_ben_in AS CÓDIGO,
                    pat_ben_vc AS PATERNO,
                    mat_ben_vc AS MATERNO,
                    nom_ben_vc AS NOMBRE,
                    CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [FECHA DE NACIMIENTO],
                    dni_ben_ch AS DNI,
                    IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS SEXO
                FROM Beneficiario
                WHERE dni_ben_ch = @parametro
            ELSE
                IF @parametro LIKE ('[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]')
                    SELECT
                        cod_ben_in AS CÓDIGO,
                        pat_ben_vc AS PATERNO,
                        mat_ben_vc AS MATERNO,
                        nom_ben_vc AS NOMBRE,
                        CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [FECHA DE NACIMIENTO],
                        dni_ben_ch AS DNI,
                        IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS SEXO
                    FROM Beneficiario
                    --WHERE fec_nac_ben_da = CONVERT(DATE, @parametro, 103)
                    WHERE fec_nac_ben_da = CAST(@parametro AS DATE)
                ELSE
                    SELECT
                        cod_ben_in AS CÓDIGO,
                        pat_ben_vc AS PATERNO,
                        mat_ben_vc AS MATERNO,
                        nom_ben_vc AS NOMBRE,
                        CONVERT(CHAR(10), fec_nac_ben_da, 103) AS [FECHA DE NACIMIENTO],
                        dni_ben_ch AS DNI,
                        IIF(cod_sex_bi=0, 'FEMENINO', 'MASCULINO') AS SEXO
                    FROM Beneficiario
                    WHERE
                        pat_ben_vc + ' ' + mat_ben_vc + ' ' +nom_ben_vc LIKE '%'+ @parametro +'%'

END
GO

----------------------------------
usp_beneficiario_consulta 'QUISPE QUISPE M'
GO