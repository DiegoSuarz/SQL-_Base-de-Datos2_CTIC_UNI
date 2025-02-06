/*
Declaración de Variables en Procedimientos Almacenados
*/

USE pvl
GO
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_beneficiario_cnt_x_comite'
)
DROP PROCEDURE usp_beneficiario_cnt_x_comite
GO
------
CREATE PROCEDURE usp_beneficiario_cnt_x_comite
(
    @cod_com_si SMALLINT
)
AS
BEGIN
    DECLARE @strSQL AS VARCHAR(500) = '''Cantidad de Beneficiarios del Comité ' + LTRIM(@cod_com_si) + '''';

    SET @strSQL = 'SELECT COUNT(*) AS ' + @strSQL + ' ';
    SET @strSQL += 'FROM Beneficiario '
    SET @strSQL += 'WHERE cod_com_si =  ' + LTRIM(@cod_com_si);

    EXECUTE(@strSQL);
END
GO

---
EXECUTE usp_beneficiario_cnt_x_comite 1000
GO