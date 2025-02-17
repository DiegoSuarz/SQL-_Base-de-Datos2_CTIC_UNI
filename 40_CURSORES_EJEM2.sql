USE Northwind
GO
-------------------------------
SELECT
    [CategoryID]
    ,[CategoryName]
    ,[Description]
FROM [dbo].[Categories];
---------------------------------



DECLARE @CategoryID     int
DECLARE @CategoryName   nvarchar(15)
DECLARE @Description    nvarchar(4000)

DECLARE ucr_categories CURSOR FOR
SELECT
    [CategoryID]
    ,[CategoryName]
    ,[Description]
FROM [dbo].[Categories];

OPEN ucr_categories;

FETCH NEXT FROM ucr_categories
INTO @CategoryID, @CategoryName, @Description;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CONCAT(@CategoryID, SPACE(2), LEFT(@CategoryName + SPACE(15), 15), SPACE(3), @Description);

    FETCH NEXT FROM ucr_categories
    INTO @CategoryID, @CategoryName, @Description;
END

CLOSE ucr_categories;
DEALLOCATE ucr_categories;