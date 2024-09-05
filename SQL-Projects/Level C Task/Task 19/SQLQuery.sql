-- Step 1: Creating the EMPLOYEES table
CREATE TABLE EMPLOYEES (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10, 2)
);


-----------------------------------------------------------


-- Step 2: Inserting sample data into the EMPLOYEES table
INSERT INTO EMPLOYEES (EmployeeID, EmployeeName, Salary) VALUES
(1, 'Alice', 5000.00),
(2, 'Bob', 6000.00),
(3, 'Charlie', 7000.00),
(4, 'David', 8000.00),
(5, 'Eve', 9000.00);


-----------------------------------------------------------


-- Step 3: Calculating the actual average salary
WITH ActualAverage AS (
    SELECT AVG(Salary) AS ActualAvgSalary
    FROM EMPLOYEES
),


-----------------------------------------------------------


-- Step 4: Calculating the miscalculated average salary with zeros removed
-- Replacing zeros with empty strings and cast back to DECIMAL
MiscalculatedAverage AS (
    SELECT AVG(CAST(REPLACE(CAST(Salary AS VARCHAR(20)), '0', '') AS DECIMAL(10, 2))) AS MiscalculatedAvgSalary
    FROM EMPLOYEES
)


-----------------------------------------------------------


-- Step 5: Calculating the error and round up to the next integer
SELECT 
    CEILING(ActualAvgSalary - MiscalculatedAvgSalary) AS ErrorRoundedUp
FROM 
    ActualAverage, MiscalculatedAverage;
