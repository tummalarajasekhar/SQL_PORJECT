-- Step 1: Creating the Function
-- Ensuring previous function is dropped before creating a new one
IF OBJECT_ID('dbo.FormatDate', 'FN') IS NOT NULL
    DROP FUNCTION dbo.FormatDate;
GO

CREATE FUNCTION dbo.FormatDate (@InputDate DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @FormattedDate VARCHAR(10);
    SET @FormattedDate = CONVERT(VARCHAR(10), @InputDate, 101);
    RETURN @FormattedDate;
END;
GO


------------------------------------------------


-- Step 2: Testing the Function
-- Testing the FormatDate function with a sample datetime
SELECT dbo.FormatDate('2006-11-21 23:34:05.920') AS FormattedDate;
