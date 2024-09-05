-- Step 1: Creating the Table
CREATE TABLE Projects (
    Task_ID INT PRIMARY KEY,
    Start_Date DATE,
    End_Date DATE
);


-----------------------------------------------------


-- Step 2: Inserting Sample Data
INSERT INTO Projects (Task_ID, Start_Date, End_Date) VALUES
(1, '2015-10-01', '2015-10-02'),
(2, '2015-10-02', '2015-10-03'),
(3, '2015-10-03', '2015-10-04'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31');


-----------------------------------------------------


-- Step 3: Writing the Query
WITH ConsecutiveTasks AS (
    SELECT
        Task_ID,
        Start_Date,
        End_Date,
        ROW_NUMBER() OVER (ORDER BY Start_Date) AS RowNum,
        DATEADD(DAY, -ROW_NUMBER() OVER (ORDER BY Start_Date), Start_Date) AS DateDiff
    FROM
        Projects
),
GroupedProjects AS (
    SELECT
        MIN(Start_Date) AS Project_Start_Date,
        MAX(End_Date) AS Project_End_Date,
        COUNT(*) AS Duration
    FROM
        ConsecutiveTasks
    GROUP BY
        DateDiff
)
SELECT
    Project_Start_Date,
    Project_End_Date
FROM
    GroupedProjects
ORDER BY
    Duration ASC,
    Project_Start_Date ASC;

