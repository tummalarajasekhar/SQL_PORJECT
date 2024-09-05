-- Step 1: Creating Tables and Inserting Data
-- Creating Hackers Table
CREATE TABLE Hackers (
    hacker_id INTEGER PRIMARY KEY,
    name VARCHAR(50)
);

-- Create Submissions Table
CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INTEGER PRIMARY KEY,
    hacker_id INTEGER,
    score INTEGER,
    FOREIGN KEY (hacker_id) REFERENCES Hackers(hacker_id)
);

-- Inserting Data into Hackers Table
INSERT INTO Hackers (hacker_id, name) VALUES 
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonnie'),
(79722, 'Michael');

-- Inserting Data into Submissions Table
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 45),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);


-----------------------------------------------------------


-- Step 2: Query to find the total number of unique hackers who made at least one submission each day
WITH DailyUniqueHackers AS (
    SELECT 
        submission_date,
        COUNT(DISTINCT hacker_id) AS unique_hackers
    FROM 
        Submissions
    GROUP BY 
        submission_date
),
DailyMaxSubmissions AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(submission_id) AS submissions_count,
        RANK() OVER (PARTITION BY submission_date ORDER BY COUNT(submission_id) DESC, hacker_id ASC) AS rank
    FROM 
        Submissions
    GROUP BY 
        submission_date, hacker_id
)
SELECT
    du.submission_date,
    du.unique_hackers,
    dm.hacker_id,
    h.name
FROM
    DailyUniqueHackers du
JOIN
    DailyMaxSubmissions dm ON du.submission_date = dm.submission_date
JOIN
    Hackers h ON dm.hacker_id = h.hacker_id
WHERE
    dm.rank = 1
ORDER BY
    du.submission_date;

drop table Submissions;