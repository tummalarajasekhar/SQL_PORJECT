-- Step 1: Creating Tables and inserting Data
-- Resetting and creating sample data in the Production.Product table
TRUNCATE TABLE Production.Product;
TRUNCATE TABLE Sales.SalesOrderDetail;

-- Inserting sample data into Production.Product table
-- Assuming ProductID is ProductID, Name is Name, ListPrice is ListPrice, SafetyStockLevel as UnitsInStock, and ReorderPoint as ReorderLevel
INSERT INTO Production.Product (ProductID, Name, ListPrice, SafetyStockLevel, ReorderPoint)
VALUES
(1, 'Product A', 10.00, 100, 20),
(2, 'Product B', 20.00, 50, 10),
(3, 'Product C', 30.00, 30, 5);

-- Inserting sample data into Sales.SalesOrderDetail table
-- Assuming SalesOrderID is OrderID, ProductID is ProductID, UnitPrice is UnitPrice, OrderQty as Quantity, and UnitPriceDiscount as Discount
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, UnitPrice, OrderQty, UnitPriceDiscount)
VALUES
(1, 1, 10.00, 5, 0),
(1, 2, 20.00, 2, 0),
(2, 3, 30.00, 1, 0);


------------------------------------------------------


-- Step 2: Creating the UpdateOrderDetails Stored Procedure
-- Ensuring previous procedure is dropped before creating a new one
IF OBJECT_ID('UpdateOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE UpdateOrderDetails;
GO

CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(18, 2) = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(4, 2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldQuantity INT;
    DECLARE @OldUnitPrice DECIMAL(18, 2);
    DECLARE @OldDiscount DECIMAL(4, 2);
    DECLARE @NewUnitPrice DECIMAL(18, 2);
    DECLARE @NewQuantity INT;
    DECLARE @NewDiscount DECIMAL(4, 2);

    -- Retrieving the existing order details
    SELECT @OldQuantity = Quantity, 
           @OldUnitPrice = UnitPrice, 
           @OldDiscount = Discount
    FROM [Order Details]
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    -- Ensuring the order detail exists
    IF @OldQuantity IS NULL
    BEGIN
        PRINT 'Invalid OrderID or ProductID. No such order detail exists.';
        RETURN;
    END

    -- Set new values, retaining old ones if NULL is provided
    SET @NewUnitPrice = ISNULL(@UnitPrice, @OldUnitPrice);
    SET @NewQuantity = ISNULL(@Quantity, @OldQuantity);
    SET @NewDiscount = ISNULL(@Discount, @OldDiscount);

    -- Updating the order details
    UPDATE [Order Details]
    SET UnitPrice = @NewUnitPrice,
        Quantity = @NewQuantity,
        Discount = @NewDiscount
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    -- Adjusting the UnitsInStock in the Products table
    DECLARE @StockAdjustment INT;
    SET @StockAdjustment = @OldQuantity - @NewQuantity;

    UPDATE Products
    SET UnitsInStock = UnitsInStock + @StockAdjustment
    WHERE ProductID = @ProductID;

    PRINT 'Order details updated successfully.';
END;
GO


------------------------------------------------------


-- Step 3: Testing the Stored Procedure
-- Testing updating only Quantity
EXEC UpdateOrderDetails @OrderID = 1, @ProductID = 1, @Quantity = 10;

-- Testing updating UnitPrice and Discount while keeping original Quantity
EXEC UpdateOrderDetails @OrderID = 1, @ProductID = 1, @UnitPrice = 15.00, @Discount = 0.05;

-- Testing updating all parameters
EXEC UpdateOrderDetails @OrderID = 1, @ProductID = 1, @UnitPrice = 12.00, @Quantity = 8, @Discount = 0.1;

-- Testing updating with no changes
EXEC UpdateOrderDetails @OrderID = 1, @ProductID = 1;
