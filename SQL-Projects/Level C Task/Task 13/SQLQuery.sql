-- Step 1 : Creating Tables
CREATE TABLE BU (
    BU_ID INTEGER,
    BU_Name VARCHAR(100)
);

CREATE TABLE Cost (
    BU_ID INTEGER,
    Month DATE,
    Cost FLOAT
);

CREATE TABLE Revenue (
    BU_ID INTEGER,
    Month DATE,
    Revenue FLOAT
);


----------------------------------------


-- Step 2 : Inserting Sample Data
INSERT INTO BU (BU_ID, BU_Name) VALUES
(1, 'BU1'),
(2, 'BU2');

INSERT INTO Cost (BU_ID, Month, Cost) VALUES
(1, '2024-01-01', 50000),
(1, '2024-02-01', 60000),
(2, '2024-01-01', 30000),
(2, '2024-02-01', 40000);

INSERT INTO Revenue (BU_ID, Month, Revenue) VALUES
(1, '2024-01-01', 100000),
(1, '2024-02-01', 120000),
(2, '2024-01-01', 80000),
(2, '2024-02-01', 90000);


----------------------------------------


-- Step 3 : Query to Calculate Ratio of Cost and Revenue of a BU Month on Month
WITH CostRevenue AS (
    SELECT 
        c.BU_ID,
        c.Month,
        c.Cost,
        r.Revenue,
        (c.Cost / r.Revenue) AS CostRevenueRatio
    FROM 
        Cost c
    JOIN 
        Revenue r ON c.BU_ID = r.BU_ID AND c.Month = r.Month
)
SELECT 
    bu.BU_Name,
    cr.Month,
    cr.Cost,
    cr.Revenue,
    cr.CostRevenueRatio
FROM 
    CostRevenue cr
JOIN 
    BU bu ON cr.BU_ID = bu.BU_ID
ORDER BY 
    bu.BU_Name, cr.Month;
