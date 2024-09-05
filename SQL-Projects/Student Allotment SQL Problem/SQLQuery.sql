-- Step 1: Creating the tables

CREATE TABLE StudentDetails (
    Studentid INT PRIMARY KEY,
    StudentName VARCHAR(255),
    GPA FLOAT,
    Branch VARCHAR(50),
    Section VARCHAR(5)
);

CREATE TABLE SubjectDetails (
    Subjectid VARCHAR(50) PRIMARY KEY,
    SubjectName VARCHAR(255),
    MaxSeats INT,
    RemainingSeats INT
);

CREATE TABLE StudentPreference (
    Studentid INT,
    Subjectid VARCHAR(50),
    Preference INT,
    FOREIGN KEY (Studentid) REFERENCES StudentDetails(Studentid),
    FOREIGN KEY (Subjectid) REFERENCES SubjectDetails(Subjectid),
    PRIMARY KEY (Studentid, Preference)
);

CREATE TABLE Allotments (
    Subjectid VARCHAR(50),
    Studentid INT,
    FOREIGN KEY (Subjectid) REFERENCES SubjectDetails(Subjectid),
    FOREIGN KEY (Studentid) REFERENCES StudentDetails(Studentid)
);

CREATE TABLE UnallotedStudents (
    Studentid INT PRIMARY KEY,
    FOREIGN KEY (Studentid) REFERENCES StudentDetails(Studentid)
);


----------------------------------------------------------------


-- Step 2: Inserting sample data

INSERT INTO StudentDetails (Studentid, StudentName, GPA, Branch, Section)
VALUES
(159103036, 'Mohit Agarwal', 8.9, 'CCE', 'A'),
(159103037, 'Rohit Agarwal', 5.2, 'CCE', 'A'),
(159103038, 'Shohit Garg', 7.1, 'CCE', 'B'),
(159103039, 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
(159103040, 'Mehreet Singh', 5.6, 'CCE', 'A'),
(159103041, 'Arjun Tehlan', 9.2, 'CCE', 'B');

INSERT INTO SubjectDetails (Subjectid, SubjectName, MaxSeats, RemainingSeats)
VALUES
('P01491', 'Basics of Political Science', 60, 2),
('P01492', 'Basics of Accounting', 120, 119),
('P01493', 'Basics of Financial Markets', 90, 90),
('P01494', 'Eco philosophy', 60, 50),
('P01495', 'Automotive Trends', 60, 60);

INSERT INTO StudentPreference (Studentid, Subjectid, Preference)
VALUES
(159103036, 'P01491', 1),
(159103036, 'P01492', 2),
(159103036, 'P01493', 3),
(159103036, 'P01494', 4),
(159103036, 'P01495', 5);


----------------------------------------------------------------


-- Step 3: Creating the stored procedure

GO

CREATE PROCEDURE AllocateSubjects
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sid INT;
    DECLARE @gpa FLOAT;
    DECLARE @pref INT;
    DECLARE @subj_id VARCHAR(50);
    DECLARE @subj_seats INT;

    DECLARE cur CURSOR FOR
        SELECT Studentid, GPA
        FROM StudentDetails
        ORDER BY GPA DESC;

    OPEN cur;

    FETCH NEXT FROM cur INTO @sid, @gpa;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @pref = 1;
        DECLARE @allocated BIT = 0;

        WHILE @pref <= 5 AND @allocated = 0
        BEGIN
            SELECT @subj_id = Subjectid
            FROM StudentPreference
            WHERE Studentid = @sid AND Preference = @pref;

            SELECT @subj_seats = RemainingSeats
            FROM SubjectDetails
            WHERE Subjectid = @subj_id;

            IF @subj_seats > 0
            BEGIN
                INSERT INTO Allotments (Subjectid, Studentid)
                VALUES (@subj_id, @sid);

                UPDATE SubjectDetails
                SET RemainingSeats = RemainingSeats - 1
                WHERE Subjectid = @subj_id;

                SET @allocated = 1;
            END
            ELSE
            BEGIN
                SET @pref = @pref + 1;
            END
        END

        IF @allocated = 0
        BEGIN
            INSERT INTO UnallotedStudents (Studentid)
            VALUES (@sid);
        END

        FETCH NEXT FROM cur INTO @sid, @gpa;
    END

    CLOSE cur;
    DEALLOCATE cur;
END
GO


----------------------------------------------------------------


-- Step 4: Executing the stored procedure
    
EXEC AllocateSubjects;
