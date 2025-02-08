--ENVÍO DE CONSULTA SQL A EXCEL

sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
sp_configure
GO

-------------------------------------------------------------------------
--Para acceder a Excel y al DOS

sp_configure 'show advanced options', 1
GO
sp_configure 'Ad Hoc Distributed Queries', 1
GO
sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE
GO
sp_configure
GO