-- Step 1: Creating the Function
-- Ensuring previous function is dropped before creating a new one
IF OBJECT_ID('dbo.FormatDateYYYYMMDD', 'FN') IS NOT NULL
    DROP FUNCTION dbo.FormatDateYYYYMMDD;
GO

CREATE FUNCTION dbo.FormatDateYYYYMMDD (@InputDate DATETIME)
RETURNS VARCHAR(8)
AS
BEGIN
    DECLARE @FormattedDate VARCHAR(8);
    SET @FormattedDate = CONVERT(VARCHAR(8), @InputDate, 112);
    RETURN @FormattedDate;
END;
GO


------------------------------------------------


-- Step 2: Testing the Function
-- Testing the FormatDateYYYYMMDD function with a sample datetime
SELECT dbo.FormatDateYYYYMMDD('2006-11-21 23:34:05.920') AS FormattedDate;
