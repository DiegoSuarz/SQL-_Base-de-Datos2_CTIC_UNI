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
	--SELECT DATENAME(WEEKDAY,'19961026')  --DIA DE LA SEMANA
    SELECT DATENAME(WEEKDAY,'19910905') --DIA DE LA SEMANA
	
)
SELECT @Día AS [El día que haz nacido];


DECLARE @Años NVARCHAR(30) =
(
	SELECT convert(int,DATEDIFF(DAY,'19910905','20250214')/365.256363004)
)
SELECT @Años AS [Cuanto años tienes:];