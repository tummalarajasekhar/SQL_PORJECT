-- Step 1: Creating Sample Data
-- Ensuring tables have sample data
-- Inserting sample data into Sales.SalesOrderDetail table
IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail)
BEGIN
    INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, UnitPrice, OrderQty, UnitPriceDiscount)
    VALUES
    (1, 1, 10.00, 5, 0),
    (1, 2, 20.00, 2, 0),
    (2, 3, 30.00, 1, 0);
END


---------------------------------------------------


-- Step 2: Creating the GetOrderDetails Stored Procedure
-- Ensuring previous procedure is dropped before creating a new one
IF OBJECT_ID('GetOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE GetOrderDetails;
GO

CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Checking if there are any records for the given OrderID
    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @OrderID)
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR(10)) + ' does not exist.';
        RETURN 1;
    END

    -- Returning the order details for the given OrderID
    SELECT SalesOrderID AS OrderID,
           ProductID,
           UnitPrice,
           OrderQty AS Quantity,
           UnitPriceDiscount AS Discount
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID;
END;
GO


---------------------------------------------------


-- Step 3: Testing the Stored Procedure
-- Testing with an existing OrderID
EXEC GetOrderDetails @OrderID = 1;

-- Testing with a non-existing OrderID
EXEC GetOrderDetails @OrderID = 99;
