/*
DECLARACION DE VARIABLES EN PROCEDIMIENTOS ALMACENADOS

Declaraci�n de Variables de Tipo de Datos Espec�ficos
SQL Server permite declarar variables de tipos de datos espec�ficos, 
como DATETIME, DECIMAL, etc.
*/


DECLARE @Fecha DATETIME = GetDate()

SELECT @Fecha AS Fecha;

-------------------------------------------------------------

DECLARE @D�a NVARCHAR(30) =
(
    SELECT DATENAME(WEEKDAY,'19961026')  --DIA DE LA SEMANA
)
SELECT @D�a AS [El d�a que haz nacido];