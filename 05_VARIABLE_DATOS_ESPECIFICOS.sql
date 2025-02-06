/*
DECLARACION DE VARIABLES EN PROCEDIMIENTOS ALMACENADOS

Declaración de Variables de Tipo de Datos Específicos
SQL Server permite declarar variables de tipos de datos específicos, 
como DATETIME, DECIMAL, etc.
*/


DECLARE @Fecha DATETIME = GetDate()

SELECT @Fecha AS Fecha;

-------------------------------------------------------------

DECLARE @Día NVARCHAR(30) =
(
    SELECT DATENAME(WEEKDAY,'19961026')  --DIA DE LA SEMANA
)
SELECT @Día AS [El día que haz nacido];