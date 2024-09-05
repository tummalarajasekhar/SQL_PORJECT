-- Step 1 : Creating Tables
CREATE TABLE JobFamily (
    JobFamilyID INTEGER,
    JobFamilyName VARCHAR(100)
);

CREATE TABLE Cost (
    JobFamilyID INTEGER,
    Location VARCHAR(50),
    Cost FLOAT
);


------------------------------------------


-- Step 2 : Inserting Sample Data
INSERT INTO JobFamily (JobFamilyID, JobFamilyName) VALUES
(1, 'Engineering'),
(2, 'Marketing'),
(3, 'Sales');

INSERT INTO Cost (JobFamilyID, Location, Cost) VALUES
(1, 'India', 50000),
(1, 'International', 70000),
(2, 'India', 30000),
(2, 'International', 50000),
(3, 'India', 40000),
(3, 'International', 60000);


------------------------------------------


-- Step 3 : Query to Calculate Ratio of Cost of Job Family in Percentage by India and International
WITH TotalCost AS (
    SELECT 
        Location,
        SUM(Cost) AS TotalCost
    FROM 
        Cost
    GROUP BY 
        Location
), CostPercentage AS (
    SELECT 
        JobFamilyID,
        Location,
        Cost,
        (Cost / (SELECT SUM(Cost) FROM Cost WHERE Location = c.Location)) * 100 AS CostPercentage
    FROM 
        Cost c
)
SELECT 
    jf.JobFamilyName,
    cp.Location,
    cp.CostPercentage
FROM 
    CostPercentage cp
JOIN 
    JobFamily jf ON cp.JobFamilyID = jf.JobFamilyID
ORDER BY 
    jf.JobFamilyName, cp.Location;
