-- Step 1: Creating the View vwCustomerOrders
-- Ensuring the view does not already exist before creating it
IF OBJECT_ID('Sales.vwCustomerOrders', 'V') IS NOT NULL
    DROP VIEW Sales.vwCustomerOrders;
GO

CREATE VIEW Sales.vwCustomerOrders AS
SELECT 
    c.AccountNumber AS CompanyName, 
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    sod.OrderQty * sod.UnitPrice AS TotalPrice
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
JOIN 
    Sales.Customer c ON soh.CustomerID = c.CustomerID;
GO


--------------------------------------------------------


-- Step 2: Creating the View vwCustomerOrdersYesterday
-- Ensuring the view does not already exist before creating it
IF OBJECT_ID('Sales.vwCustomerOrdersYesterday', 'V') IS NOT NULL
    DROP VIEW Sales.vwCustomerOrdersYesterday;
GO

CREATE VIEW Sales.vwCustomerOrdersYesterday AS
SELECT 
    c.AccountNumber AS CompanyName, -- Placeholder for actual company name field
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    sod.OrderQty * sod.UnitPrice AS TotalPrice
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
JOIN 
    Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE 
    soh.OrderDate = CAST(GETDATE() - 1 AS DATE);
GO


--------------------------------------------------------


-- Step 3: Creating the View MyProducts
-- Ensuring the view does not already exist before creating it
IF OBJECT_ID('Production.MyProducts', 'V') IS NOT NULL
    DROP VIEW Production.MyProducts;
GO

CREATE VIEW Production.MyProducts AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.Size AS QuantityPerUnit, 
    p.ListPrice AS UnitPrice, 
    v.Name AS CompanyName,  
    c.Name AS CategoryName
FROM 
    Production.Product p
JOIN 
    Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN 
    Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
JOIN 
    Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN 
    Production.ProductCategory c ON ps.ProductCategoryID = c.ProductCategoryID
WHERE 
    p.DiscontinuedDate IS NULL;
GO


