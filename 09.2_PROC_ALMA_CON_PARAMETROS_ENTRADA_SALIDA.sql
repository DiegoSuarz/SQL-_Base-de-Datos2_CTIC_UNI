/*
PROCEDIMIENTOS ALMACENADOS CON PARÁMETRO DE ENTRADA Y SALIDA
*/

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

------
CREATE PROCEDURE usp_beneficiario_cnt_x_comite
(
    @cod_com_si SMALLINT,
    @cnt        SMALLINT OUTPUT
)
AS
BEGIN
    SELECT @cnt = COUNT(*)
    FROM Beneficiario
    WHERE cod_com_si = @cod_com_si

    RETURN 0
END
GO


--------------------------------------
DECLARE @Error INT;
DECLARE @Cantidad INT;
EXECUTE @Error = usp_beneficiario_cnt_x_comite 123, @Cantidad OUTPUT
SELECT @Cantidad AS Cantidad
SELECT @Error AS Error