-- Step 1: Creating the Table
CREATE TABLE ExampleTable (
    ID INT PRIMARY KEY,
    ColumnA INT,
    ColumnB INT
);


---------------------------------------------


-- Step 2: Inserting Sample Data
INSERT INTO ExampleTable (ID, ColumnA, ColumnB) VALUES
(1, 10, 20),
(2, 30, 40),
(3, 50, 60);


---------------------------------------------


-- Step 3: Writing the Query to Swap Values
UPDATE ExampleTable
SET ColumnA = ColumnA + ColumnB;
UPDATE ExampleTable
SET ColumnB = ColumnA - ColumnB;
UPDATE ExampleTable
SET ColumnA = ColumnA - ColumnB;


---------------------------------------------


-- Step 4: Verifying the Swap
SELECT * FROM ExampleTable;

