-- Step 1: Creating the Tables
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10, 2)
);


------------------------------------------------


-- Step 2: Inserting Sample Data
INSERT INTO Employee (EmployeeID, EmployeeName, Salary) VALUES
(1, 'Alice', 75000.00),
(2, 'Bob', 82000.00),
(3, 'Charlie', 68000.00),
(4, 'David', 91000.00),
(5, 'Eve', 72000.00),
(6, 'Frank', 66000.00),
(7, 'Grace', 85000.00),
(8, 'Heidi', 93000.00),
(9, 'Ivan', 87000.00),
(10, 'Judy', 95000.00);


------------------------------------------------


-- Step 3: Writing the Query
WITH RankedEmployees AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS Rank
    FROM Employee
)
SELECT 
    EmployeeID,
    EmployeeName,
    Salary
FROM RankedEmployees
WHERE Rank <= 5;
