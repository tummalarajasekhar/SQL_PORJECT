-- Step 1 : Creating tables
CREATE TABLE Students (
    ID INTEGER,
    Name VARCHAR(100)
);

CREATE TABLE Friends (
    ID INTEGER,
    Friend_ID INTEGER
);

CREATE TABLE Packages (
    ID INTEGER,
    Salary FLOAT
);


----------------------------------------------


-- Step 2 : Inserting sample data
INSERT INTO Students (ID, Name) VALUES (2, 'Ashley'), (3, 'Samantha'), (4, 'Julia'), (1, 'Scarlet');

INSERT INTO Friends (ID, Friend_ID) VALUES (1, 2), (2, 3), (3, 4), (4, 1);

INSERT INTO Packages (ID, Salary) VALUES (2, 15.20), (3, 10.06), (4, 11.55), (1, 12.12);


----------------------------------------------


-- Step 3 : Query to get the required output
SELECT 
    s1.Name
FROM 
    Friends f
JOIN 
    Students s1 ON f.ID = s1.ID
JOIN 
    Packages p1 ON s1.ID = p1.ID
JOIN 
    Students s2 ON f.Friend_ID = s2.ID
JOIN 
    Packages p2 ON s2.ID = p2.ID
WHERE 
    p2.Salary > p1.Salary
ORDER BY 
    p2.Salary;
