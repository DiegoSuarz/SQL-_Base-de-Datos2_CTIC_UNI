USE Northwind
GO

SET NOCOUNT ON;

DECLARE @CategoryID            int;
DECLARE @CategoryName        nvarchar(15);
DECLARE @Description        nvarchar(4000);

DECLARE ucr_categoria CURSOR
FOR
    SELECT CategoryID, CategoryName, Description
    FROM Categories;

OPEN ucr_categoria;

FETCH NEXT FROM ucr_categoria
INTO
    @CategoryID,
    @CategoryName,
    @Description;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CONCAT(@CategoryID, ': ', @CategoryName)
    FETCH NEXT FROM ucr_categoria
    INTO
        @CategoryID,
        @CategoryName,
        @Description;
END
CLOSE ucr_categoria;
DEALLOCATE ucr_categoria;
GO