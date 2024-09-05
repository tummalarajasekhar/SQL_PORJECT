-- Step 1 : Creating Sample Tables and Inserting Data
-- Creating the Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name NVARCHAR(50),
    UnitPrice DECIMAL(18, 2),
    UnitsInStock INT,
    ReorderLevel INT
);

-- Creating the Order Details table
CREATE TABLE [Order Details] (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(18, 2),
    Quantity INT,
    Discount DECIMAL(4, 2)
);

-- Inserting sample data into Products table
INSERT INTO Products (ProductID, Name, UnitPrice, UnitsInStock, ReorderLevel)
VALUES
(1, 'Product A', 10.00, 100, 20),
(2, 'Product B', 20.00, 50, 10),
(3, 'Product C', 30.00, 30, 5);

-- Inserting sample data into Order Details table
INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES
(1, 1, 10.00, 5, 0),
(1, 2, 20.00, 2, 0),
(2, 3, 30.00, 1, 0);


-----------------------------------------------------


-- Step 2 : Creating the Stored Procedure
GO

CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(18, 2) = NULL,
    @Quantity INT,
    @Discount DECIMAL(4, 2) = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentUnitPrice DECIMAL(18, 2);
    DECLARE @UnitsInStock INT;
    DECLARE @ReorderLevel INT;

    -- Get the current UnitPrice from the Products table if not provided
    IF @UnitPrice IS NULL
    BEGIN
        SELECT @CurrentUnitPrice = UnitPrice
        FROM Products
        WHERE ProductID = @ProductID;

        IF @CurrentUnitPrice IS NULL
        BEGIN
            PRINT 'Invalid ProductID. No such product exists.';
            RETURN;
        END
    END
    ELSE
    BEGIN
        SET @CurrentUnitPrice = @UnitPrice;
    END

    -- Get the current stock and reorder level
    SELECT @UnitsInStock = UnitsInStock, @ReorderLevel = ReorderLevel
    FROM Products
    WHERE ProductID = @ProductID;

    IF @UnitsInStock IS NULL
    BEGIN
        PRINT 'Invalid ProductID. No such product exists.';
        RETURN;
    END

    -- Checking if there is enough stock
    IF @UnitsInStock < @Quantity
    BEGIN
        PRINT 'Not enough stock available to fulfill the order.';
        RETURN;
    END

    -- Inserting the order details
    INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @CurrentUnitPrice, @Quantity, @Discount);

    -- Checking if the order was inserted successfully
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END

    -- Updating the stock quantity
    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;

    -- Checking if the stock quantity has dropped below the reorder level
    IF @UnitsInStock - @Quantity < @ReorderLevel
    BEGIN
        PRINT 'The quantity in stock of this product has dropped below its reorder level.';
    END
END;

GO


-----------------------------------------------------


--Step 3 : Testing the Stored Procedure
-- Testing with sufficient stock
EXEC InsertOrderDetails @OrderID = 3, @ProductID = 1, @Quantity = 10;

-- Testing with insufficient stock
EXEC InsertOrderDetails @OrderID = 3, @ProductID = 2, @Quantity = 60;

-- Test with default UnitPrice and Discount
EXEC InsertOrderDetails @OrderID = 3, @ProductID = 3, @Quantity = 5;

