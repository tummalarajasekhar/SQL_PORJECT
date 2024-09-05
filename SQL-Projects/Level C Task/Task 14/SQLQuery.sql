-- Step 1: Creating the Tables
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    SubBand VARCHAR(10)
);


------------------------------------------


-- Step 2: Inserting Sample Data
INSERT INTO Employee (EmployeeID, EmployeeName, SubBand) VALUES
(1, 'Alice', 'A1'),
(2, 'Bob', 'A2'),
(3, 'Charlie', 'A1'),
(4, 'David', 'A3'),
(5, 'Eve', 'A2'),
(6, 'Frank', 'A1'),
(7, 'Grace', 'A3'),
(8, 'Heidi', 'A2'),
(9, 'Ivan', 'A1'),
(10, 'Judy', 'A2');


------------------------------------------


-- Step 3: Writing the Query
WITH TotalCount AS (
    SELECT COUNT(*) AS Total FROM Employee
)
SELECT 
    SubBand,
    COUNT(*) AS HeadCount,
    ROUND((COUNT(*) * 100.0 / (SELECT Total FROM TotalCount)), 2) AS Percentage
FROM Employee
GROUP BY SubBand;

