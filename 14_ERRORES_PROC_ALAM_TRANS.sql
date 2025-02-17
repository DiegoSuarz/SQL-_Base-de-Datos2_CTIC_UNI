--ERRORES PROCEDIMIENTOS ALMACENDOS TRANSACCIONALES
--crear tabla de errores:
IF EXISTS  -- SI EXISTE LA TABLA tbl_error_usp, ELIMINALO
(
    SELECT name
    FROM sys.tables
    WHERE name = 'tbl_error_usp'
)
DROP TABLE tbl_error_usp
GO
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_STATE() AS ErrorState,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage,
    GETDATE() AS ErrorDate
    INTO tbl_error_usp
-----------------------------------------------------------------------

TRUNCATE TABLE [dbo].[tbl_error_usp]

SELECT *
FROM [dbo].[tbl_error_usp]

-----------------------------------------------------------------------
/*
USE Northwind --SELECCIONAR BASE DE DATOS
GO
IF EXISTS
(
    SELECT name
    FROM sys.tables
    WHERE name = 'tbl_error_usp'
)
DROP TABLE rol
GO


CREATE TABLE tbl_error_usp --crear tabla rol
(
	--columnas de la tabla con su tipo de dato
   	ErrorNumber		INT,
    ErrorSeverity	INT,
    ErrorState		INT,
    ErrorProcedure	NVARCHAR(128),
    ErrorLine		INT,	
    ErrorMessage	NVARCHAR(400),
    ErrorDate		DATETIME
)
GO
*/