-- Step 1: Creating the Tables
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    BU VARCHAR(50)
);

CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY,
    EmployeeID INT,
    SalaryMonth DATE,
    SalaryAmount DECIMAL(10, 2),
    Weight DECIMAL(5, 2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-------------------------------------------------------


-- Step 2: Inserting Sample Data
INSERT INTO Employees (EmployeeID, EmployeeName, BU) VALUES
(1, 'Alice', 'Sales'),
(2, 'Bob', 'Sales'),
(3, 'Charlie', 'HR'),
(4, 'David', 'HR'),
(5, 'Eve', 'Sales');

INSERT INTO Salaries (SalaryID, EmployeeID, SalaryMonth, SalaryAmount, Weight) VALUES
(1, 1, '2024-01-01', 5000, 1.0),
(2, 1, '2024-02-01', 5100, 1.1),
(3, 2, '2024-01-01', 6000, 1.0),
(4, 2, '2024-02-01', 6100, 1.2),
(5, 3, '2024-01-01', 5500, 1.0),
(6, 3, '2024-02-01', 5600, 1.1),
(7, 4, '2024-01-01', 7000, 1.0),
(8, 4, '2024-02-01', 7100, 1.3),
(9, 5, '2024-01-01', 8000, 1.0),
(10, 5, '2024-02-01', 8100, 1.4);


-------------------------------------------------------


-- Step 3: Writing the Query to Calculate the Weighted Average Cost
SELECT 
    BU,
    SalaryMonth,
    SUM(SalaryAmount * Weight) / SUM(Weight) AS WeightedAverageCost
FROM 
    Employees e
JOIN 
    Salaries s ON e.EmployeeID = s.EmployeeID
GROUP BY 
    BU, SalaryMonth
ORDER BY 
    BU, SalaryMonth;
