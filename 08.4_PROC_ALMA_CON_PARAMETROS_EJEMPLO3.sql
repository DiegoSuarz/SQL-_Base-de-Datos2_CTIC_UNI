USE pvl
GO
-- Cantidad de beneficiarios por comite
IF EXISTS
(
    SELECT name
    FROM sys.procedures
    WHERE name = 'usp_beneficiario_cnt_x_comite'
)
DROP PROCEDURE usp_beneficiario_cnt_x_comite
GO


CREATE PROCEDURE usp_beneficiario_cnt_x_comite
(
    @cod_com_si SMALLINT
)
AS
BEGIN


    RETURN
    (
        SELECT COUNT(*)
        FROM Beneficiario
        WHERE cod_com_si = @cod_com_si
    )
END
GO

---------------------------------------
DECLARE @Error INT;
EXECUTE @Error = usp_beneficiario_cnt_x_comite 123
SELECT @Error AS Cantidad