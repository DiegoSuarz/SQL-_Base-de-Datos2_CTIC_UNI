/*
Ejemplo cursor con contadores
Realizar un procedimiento almacenado que permita el ingreso del
código del comité y me genere el encabezado con el nombre del
centro de acopio, pueblo al cual pertenece y el listado de los
beneficiarios por grupo de niños, madres gestantes, madres 
lactantes y ancianos. Deberá mostrar la cantidad de beneficiarios 
al final de cada grupo.

El reporte deberá tener 6 casillas para que firme o coloque su 
huella el beneficiario por semana.
*/

USE pvl
GO
-------
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_comite_consulta'
)
DROP PROCEDURE usp_comite_consulta
GO
------
CREATE PROCEDURE usp_comite_consulta
(
    @cod_com_si        SMALLINT
)
AS
BEGIN
    DECLARE @nom_cen_aco_vc        varchar(30)
    DECLARE @nom_pue_vc            varchar(50)
    DECLARE @nom_com_vc            varchar(40)

    SELECT
        @nom_cen_aco_vc = ca.nom_cen_aco_vc,
        @nom_pue_vc = p.nom_pue_vc,
        @nom_com_vc = c.nom_com_vc
    FROM [dbo].[CentroAcopio] ca
    INNER JOIN [dbo].[Pueblo] p
    ON ca.cod_cen_aco_ti = p.cod_cen_aco_ti
    INNER JOIN Comite c
    ON p.cod_pue_si = c.cod_pue_si
    WHERE cod_com_si=@cod_com_si

    PRINT 'PROGRAMA DE VASO DE LECHE DEL DISTRITO DE SAN JUAN DE LURIGANCHO';
    PRINT REPLICATE('─', 64);
    PRINT '';
    PRINT CONCAT(RIGHT(SPACE(18) + 'Centro de acopio: ', 18), @nom_cen_aco_vc )
    PRINT CONCAT(RIGHT(SPACE(18) + 'Pueblo: ', 18), @nom_pue_vc )
    PRINT CONCAT(RIGHT(SPACE(18) + 'Comité: ', 18), @nom_com_vc )

    DECLARE @PATERNO    varchar(30)
    DECLARE @MATERNO    varchar(30)
    DECLARE @NOMBRES    varchar(40)
    DECLARE @DNI        char(8)
    DECLARE @EDAD        int
    DECLARE @SEMANA        int
    DECLARE @GENERO        varchar(1)

    DECLARE @cnt        int

    DECLARE ucr_n CURSOR FOR
    SELECT
          [pat_ben_vc] AS PATERNO
          ,[mat_ben_vc] AS MATERNO
          ,[nom_ben_vc] AS NOMBRES
          ,[dni_ben_ch] AS DNI
          ,CONVERT(INT, DATEDIFF(DAY, [fec_nac_ben_da], '20040731') / 365.256363004) AS EDAD
          ,IIF([cod_sex_bi]=0, 'F', 'M') AS GENERO
    FROM [dbo].[Beneficiario]
    WHERE
            cod_com_si = @cod_com_si
        AND
            CONVERT(INT, DATEDIFF(DAY, [fec_nac_ben_da], '20040731') / 365.256363004) BETWEEN 0 AND 12
    ORDER BY 6, 1, 2, 3;

    OPEN ucr_n;

    FETCH NEXT FROM ucr_n
    INTO
        @PATERNO,
        @MATERNO,
        @NOMBRES,
        @DNI,
        @EDAD,
        @GENERO;

    PRINT 'NIÑOS:'
    PRINT REPLICATE('─', 132);
    SET @cnt = 0;
    PRINT CONCAT(RIGHT(SPACE(3) + LTRIM('ID'), 3), SPACE(2), LEFT('PATERNO' + SPACE(15), 15), LEFT('MATERNO' + SPACE(15), 15), LEFT('NOMBRES' + SPACE(15), 15), RIGHT(SPACE(4) + LTRIM('EDAD'),5), RIGHT(SPACE(4) + LTRIM('SEXO'), 6), ' │', RIGHT(SPACE(10) + LTRIM('LUNES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('MARTES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('MiÉRCOLES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('JUEVES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('VIERNES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('SÁBADO'), 10), ' │', SPACE(10))
    PRINT REPLICATE('─', 132);
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @cnt += 1;
        PRINT CONCAT(RIGHT(SPACE(3) + LTRIM(@cnt), 3), SPACE(2), LEFT(@PATERNO + SPACE(15), 15), LEFT(@MATERNO + SPACE(15), 15), LEFT(@NOMBRES + SPACE(15), 15), RIGHT(SPACE(4) + LTRIM(@EDAD), 4), RIGHT(SPACE(4) + LTRIM(@GENERO), 4), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10))

        FETCH NEXT FROM ucr_n
        INTO
            @PATERNO,
            @MATERNO,
            @NOMBRES,
            @DNI,
            @EDAD,
            @GENERO;
    END
    PRINT REPLICATE('─', 132);
    PRINT 'La cantidad de niños es ' + LTRIM(@cnt)
    CLOSE ucr_n;
    DEALLOCATE ucr_n;

    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    DECLARE ucr_mg CURSOR FOR
    SELECT
           [pat_ben_vc] AS PATERNO
          ,[mat_ben_vc] AS MATERNO
          ,[nom_ben_vc] AS NOMBRES
          ,[dni_ben_ch] AS DNI
          ,CONVERT(INT, DATEDIFF(DAY, [fec_emb_ben_da], '20040731') / 7) AS SEMANA
          ,IIF([cod_sex_bi]=0, 'F', 'M') AS GENERO
    FROM [dbo].[Beneficiario]
    WHERE
            cod_com_si = @cod_com_si
        AND
            CONVERT(INT, DATEDIFF(DAY, [fec_emb_ben_da], '20040731') / 7) BETWEEN 0 AND 42
    ORDER BY 6, 1, 2, 3;

    OPEN ucr_mg;

    FETCH NEXT FROM ucr_mg
    INTO
        @PATERNO,
        @MATERNO,
        @NOMBRES,
        @DNI,
        @EDAD,
        @GENERO;

    PRINT '';
    PRINT 'MADRES GESTANTES:'
    PRINT REPLICATE('─', 138);
    SET @cnt = 0;

    PRINT CONCAT(RIGHT(SPACE(3) + LTRIM('ID'), 3), SPACE(2), LEFT('PATERNO' + SPACE(15), 15), LEFT('MATERNO' + SPACE(15), 15), LEFT('NOMBRES' + SPACE(15), 15), RIGHT(SPACE(10) + LTRIM('DNI'), 10), RIGHT(SPACE(4) + LTRIM('SEM'), 4), ' │', RIGHT(SPACE(10) + LTRIM('LUNES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('MARTES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('MiÉRCOLES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('JUEVES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('VIERNES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('SÁBADO'), 10), ' │', SPACE(10))
    PRINT REPLICATE('─', 138);
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @cnt += 1;
        PRINT CONCAT(RIGHT(SPACE(3) + LTRIM(@cnt), 3), SPACE(2), LEFT(@PATERNO + SPACE(15), 15), LEFT(@MATERNO + SPACE(15), 15), LEFT(@NOMBRES + SPACE(15), 15), RIGHT(SPACE(10) + LTRIM(@DNI), 10), RIGHT(SPACE(4) + LTRIM(@EDAD), 4), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10))

        FETCH NEXT FROM ucr_mg
        INTO
            @PATERNO,
            @MATERNO,
            @NOMBRES,
            @DNI,
            @EDAD,
            @GENERO;
    END
    PRINT REPLICATE('─', 138);
    PRINT 'La cantidad de madres gestantes es ' + LTRIM(@cnt)
    CLOSE ucr_mg;
    DEALLOCATE ucr_mg;

    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    DECLARE ucr_ml CURSOR FOR
    SELECT
           [pat_ben_vc] AS PATERNO
          ,[mat_ben_vc] AS MATERNO
          ,[nom_ben_vc] AS NOMBRES
          ,[dni_ben_ch] AS DNI
          ,CONVERT(INT, DATEDIFF(DAY, [fec_lac_ben_da], '20040731') / 365.256363004) AS AÑOS
          ,IIF([cod_sex_bi]=0, 'F', 'M') AS GENERO
    FROM [dbo].[Beneficiario]
    WHERE
            cod_com_si = @cod_com_si
        AND
            CONVERT(INT, DATEDIFF(DAY, [fec_lac_ben_da], '20040731') / 365.256363004) = 0
    ORDER BY 6, 1, 2, 3;

    OPEN ucr_ml;

    FETCH NEXT FROM ucr_ml
    INTO
        @PATERNO,
        @MATERNO,
        @NOMBRES,
        @DNI,
        @EDAD,
        @GENERO;

    PRINT '';
    PRINT 'MADRES LACTANTES:'
    PRINT REPLICATE('─', 143);
    SET @cnt = 0;
    PRINT CONCAT(RIGHT(SPACE(3) + LTRIM('ID'), 3), SPACE(2), LEFT('PATERNO' + SPACE(15), 15), LEFT('MATERNO' + SPACE(15), 15), LEFT('NOMBRES' + SPACE(15), 15), LEFT(LTRIM('DNI') + SPACE(15), 15), RIGHT(SPACE(4) + LTRIM('AÑO'), 4), ' │', RIGHT(SPACE(10) + LTRIM('LUNES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('MARTES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('MiÉRCOLES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('JUEVES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('VIERNES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('SÁBADO'), 10), ' │', SPACE(10))
    PRINT REPLICATE('─', 143);
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @cnt += 1;
        PRINT CONCAT(RIGHT(SPACE(3) + LTRIM(@cnt), 3), SPACE(2), LEFT(@PATERNO + SPACE(15), 15), LEFT(@MATERNO + SPACE(15), 15), LEFT(@NOMBRES + SPACE(15), 15), LEFT(@DNI + SPACE(15), 15), RIGHT(SPACE(4) + LTRIM(@EDAD), 4), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10))

        FETCH NEXT FROM ucr_ml
        INTO
            @PATERNO,
            @MATERNO,
            @NOMBRES,
            @DNI,
            @EDAD,
            @GENERO;
    END
    PRINT REPLICATE('─', 143);
    PRINT 'La cantidad de madres lactantes es ' + LTRIM(@cnt)
    CLOSE ucr_ml;
    DEALLOCATE ucr_ml;

        -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    DECLARE ucr_a CURSOR FOR
    SELECT
           [pat_ben_vc] AS PATERNO
          ,[mat_ben_vc] AS MATERNO
          ,[nom_ben_vc] AS NOMBRES
          ,[dni_ben_ch] AS DNI
          ,CONVERT(INT, DATEDIFF(DAY, [fec_nac_ben_da], '20040731') / 365.256363004) AS AÑOS
          ,IIF([cod_sex_bi]=0, 'F', 'M') AS GENERO
    FROM [dbo].[Beneficiario]
    WHERE
            cod_com_si = @cod_com_si
        AND
        (
            (
                CONVERT(INT, DATEDIFF(DAY, [fec_nac_ben_da], '20040731') / 365.256363004) >= 60
            AND
                cod_sex_bi = 0
            )
            OR
            (
                CONVERT(INT, DATEDIFF(DAY, [fec_nac_ben_da], '20040731') / 365.256363004) >= 65
            AND
                cod_sex_bi = 1
            )
        )
    ORDER BY 6, 1, 2, 3;

    OPEN ucr_a;

    FETCH NEXT FROM ucr_a
    INTO
        @PATERNO,
        @MATERNO,
        @NOMBRES,
        @DNI,
        @EDAD,
        @GENERO;

    PRINT '';
    PRINT 'ANCIANOS:'
    PRINT REPLICATE('─', 143);
    SET @cnt = 0;
    PRINT CONCAT(RIGHT(SPACE(3) + LTRIM('ID'), 3), SPACE(2), LEFT('PATERNO' + SPACE(15), 15), LEFT('MATERNO' + SPACE(15), 15), LEFT('NOMBRES' + SPACE(15), 15), LEFT(LTRIM('DNI') + SPACE(15), 15), RIGHT(SPACE(4) + LTRIM('EDAD'), 4), ' │', RIGHT(SPACE(10) + LTRIM('LUNES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('MARTES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('MiÉRCOLES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('JUEVES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('VIERNES'), 10), ' │', RIGHT(SPACE(10) + LTRIM('SÁBADO'), 10), ' │', SPACE(10))
    PRINT REPLICATE('─', 143);
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @cnt += 1;
        PRINT CONCAT(RIGHT(SPACE(3) + LTRIM(@cnt), 3), SPACE(2), LEFT(@PATERNO + SPACE(15), 15), LEFT(@MATERNO + SPACE(15), 15), LEFT(@NOMBRES + SPACE(15), 15), LEFT(@DNI + SPACE(15), 15), RIGHT(SPACE(4) + LTRIM(@EDAD), 4), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10), ' │', SPACE(10))

        FETCH NEXT FROM ucr_a
        INTO
            @PATERNO,
            @MATERNO,
            @NOMBRES,
            @DNI,
            @EDAD,
            @GENERO;
    END
    PRINT REPLICATE('─', 143);
    PRINT 'La cantidad de ancianos es ' + LTRIM(@cnt)
    CLOSE ucr_a;
    DEALLOCATE ucr_a;

    RETURN 0;
END
GO

----------------------------------------------------------------------
usp_comite_consulta 843
GO