/*
¿Qué son las Funciones en SQL Server?
Las funciones en SQL Server son bloques de código que se pueden 
reutilizar y que realizan una tarea específica.

Tipos de Funciones

- Funciones Escalares
	Estas devuelven un solo valor< y pueden ser utilizadas en 
	consultas SQL, como en las cláusulas SELECT, WHERE, ORDER BY, etc.

	Un ejemplo de función escalar es LEN(), que devuelve la longitud 
	de una cadena.

- Funciones de Tabla
	Funciones con valores de tabla insertados:
		Las funciones con valores de tabla insertados en SQL Server 
		son un tipo de función que permite devolver un conjunto de
		resultados como una tabla.

	Funciones con valores de tabla de múltiples instrucciones:
		Las funciones con valores de tabla de múltiples instrucciones 
		en SQL Server son un tipo específico de función de tabla que 
		permite ejecutar más de una instrucción SQL dentro de su 
		definición.
*/

USE Northwind
GO
IF EXISTS
(
    SELECT name
    FROM sysobjects
    WHERE
            xtype = 'FN'  --EXISTE UNA FUNCIÓN?
        AND
            name = 'ufn_customers_companyName'
)
DROP FUNCTION ufn_customers_companyName
GO
CREATE FUNCTION ufn_customers_companyName
(
    @CustomerID nvarchar(5)
)
RETURNS nvarchar(40) --VA A DEVOLVER UNA VARIABLA NVARCHAR(40)
AS
BEGIN
    DECLARE @CompanyName nvarchar(40)

    SELECT @CompanyName=CompanyName
    FROM Customers
    WHERE CustomerID = @CustomerID
    RETURN @CompanyName
END
GO

SELECT [OrderID]
      ,dbo.ufn_customers_companyName([CustomerID]) AS Cliente
      ,dbo.ufn_employees_nombre_empleado([EmployeeID]) AS Empleado
      ,[OrderDate]
      ,[RequiredDate]
      ,[ShippedDate]
      ,[ShipVia]
      ,[Freight]
      ,[ShipName]
      ,[ShipAddress]
      ,[ShipCity]
      ,[ShipRegion]
      ,[ShipPostalCode]
      ,[ShipCountry]
  FROM [dbo].[Orders]
GO