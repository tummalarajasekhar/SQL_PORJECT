-- Step 1 : Creating the OCCUPATIONS Table
CREATE TABLE OCCUPATIONS (
    Name VARCHAR(50),
    Occupation VARCHAR(50)
);


---------------------------------------------------


-- Step 2 : Inserting sample data into the OCCUPATIONS Table
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Samantha', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Julia', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Maria', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Meera', 'Singer');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Ashely', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Ketty', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Christeen', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Jane', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Jenny', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Priya', 'Singer');


---------------------------------------------------


-- Step 3 : Query to pivot the data
WITH RankedNames AS (
    SELECT 
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS RowNum
    FROM 
        OCCUPATIONS
)
SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM
    RankedNames
GROUP BY
    RowNum
ORDER BY
    RowNum;
