-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Diego suarez
-- Create date: 07/02/2025
-- Description:	obtiene el nombre del empleado de forma completa por el codigo del empleado
-- =============================================
CREATE OR ALTER FUNCTION ufn_employees_nombre_empleado 
(
	-- Add the parameters for the function here
	@employeeid int
)
RETURNS Nvarchar(45)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @nombre nvarchar(45)

	-- Add the T-SQL statements to compute the return value here
	SELECT @nombre = CONCAT([TitleOfCourtesy], SPACE(1), [LastName], ', ', [FirstName])
	FROM Employees
	WHERE EmployeeID = @employeeid
	-- Return the result of the function
	RETURN @nombre

END
GO

-------------------------------------------------------------
--EJECUTAR FUNCION:
SELECT dbo.ufn_employees_nombre_empleado(1) AS Empleado --devuelve el nombre del empleado numero 1
GO

-------------------------------------------------------------
USE [Northwind]
GO

SELECT [OrderID]
      ,[CustomerID]
      ,[EmployeeID]
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