-- Step 1: Creating the SourceTable and DestinationTable
CREATE TABLE SourceTable (
    ID INT PRIMARY KEY,
    Data VARCHAR(100)
);

CREATE TABLE DestinationTable (
    ID INT PRIMARY KEY,
    Data VARCHAR(100)
);


--------------------------------------------------------


-- Step 2: Inserting sample data 
INSERT INTO SourceTable (ID, Data) VALUES
(1, 'Alpha'),
(2, 'Beta'),
(3, 'Gamma'),
(4, 'Delta'),
(5, 'Epsilon');

INSERT INTO DestinationTable (ID, Data) VALUES
(1, 'Alpha'),
(2, 'Beta');


--------------------------------------------------------


-- Step 3: Checking the Contents Before Copying
SELECT * FROM SourceTable;
SELECT * FROM DestinationTable;


--------------------------------------------------------


-- Step 4: Inserting new data from SourceTable to DestinationTable
INSERT INTO DestinationTable (ID, Data)
SELECT ID, Data
FROM SourceTable
EXCEPT
SELECT ID, Data
FROM DestinationTable;


--------------------------------------------------------


-- Step 5: Checking the Contents after Copying
SELECT * FROM SourceTable;
SELECT * FROM DestinationTable;
