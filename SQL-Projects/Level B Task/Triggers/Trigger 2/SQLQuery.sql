-- Step 1 : Creating the Products tables and inserting sample data
IF OBJECT_ID('Products', 'U') IS NOT NULL
DROP TABLE Products;
GO

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    UnitsInStock INT
);
GO

IF OBJECT_ID('Orders', 'U') IS NOT NULL
DROP TABLE Orders;
GO

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATETIME,
    CustomerID INT
);
GO

IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL
DROP TABLE OrderDetails;
GO

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Inserting sample data into the Products table
INSERT INTO Products (ProductID, ProductName, UnitsInStock) VALUES
(100, 'ProductA', 50),
(101, 'ProductB', 20),
(102, 'ProductC', 0);
GO

-- Inserting sample data into the Orders table
INSERT INTO Orders (OrderID, OrderDate, CustomerID) VALUES
(1, '2022-01-01', 101),
(2, '2022-01-02', 102),
(3, '2022-01-03', 103);
GO


----------------------------------------------------------------


-- Step 2 : Creating the INSTEAD OF INSERT trigger on the OrderDetails table
CREATE TRIGGER trgCheckStockBeforeInsert
ON OrderDetails
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductID INT, @Quantity INT, @UnitsInStock INT;

    -- Looping through each row in the inserted pseudo table
    DECLARE order_cursor CURSOR FOR
    SELECT ProductID, Quantity
    FROM inserted;

    OPEN order_cursor;

    FETCH NEXT FROM order_cursor INTO @ProductID, @Quantity;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Checking the stock
        SELECT @UnitsInStock = UnitsInStock
        FROM Products
        WHERE ProductID = @ProductID;

        -- If sufficient stock exists
        IF @UnitsInStock >= @Quantity
        BEGIN
            -- Inserting the order detail
            INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
            SELECT OrderDetailID, OrderID, ProductID, Quantity
            FROM inserted;

            -- Decrementing the stock
            UPDATE Products
            SET UnitsInStock = UnitsInStock - @Quantity
            WHERE ProductID = @ProductID;
        END
        ELSE
        BEGIN
            -- Notifying the user that the order could not be filled
            RAISERROR ('Order could not be filled because of insufficient stock for ProductID %d.', 16, 1, @ProductID);
        END

        FETCH NEXT FROM order_cursor INTO @ProductID, @Quantity;
    END

    CLOSE order_cursor;
    DEALLOCATE order_cursor;
END;
GO


----------------------------------------------------------------


-- Step 3 : Testing the Trigger
-- Attempting to insert an order detail with sufficient stock
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
VALUES (1, 1, 100, 10); -- This should succeed

-- Attempting to insert an order detail with insufficient stock
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
VALUES (2, 1, 102, 10); -- This should fail and raise an error

-- Checking the results
SELECT * FROM OrderDetails;
SELECT * FROM Products;
