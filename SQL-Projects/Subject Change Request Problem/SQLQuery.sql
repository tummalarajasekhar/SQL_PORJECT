-- Step 1: Creating the tables

CREATE TABLE SubjectAllotments (
    StudentID VARCHAR(50),
    SubjectID VARCHAR(50),
    Is_Valid BIT
);

CREATE TABLE SubjectRequest (
    StudentID VARCHAR(50),
    SubjectID VARCHAR(50)
);


---------------------------------------------------


-- Step 2: Inserting sample data

INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid) VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);

INSERT INTO SubjectRequest (StudentID, SubjectID) VALUES
('159103036', 'PO1496');


---------------------------------------------------


-- Step 3: Creating the stored procedure

CREATE PROCEDURE ProcessSubjectRequest
AS
BEGIN
    DECLARE @StudentID VARCHAR(50);
    DECLARE @RequestedSubjectID VARCHAR(50);
    DECLARE @CurrentSubjectID VARCHAR(50);

    DECLARE request_cursor CURSOR FOR
    SELECT StudentID, SubjectID FROM SubjectRequest;

    OPEN request_cursor;
    FETCH NEXT FROM request_cursor INTO @StudentID, @RequestedSubjectID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Checking if the student already has an active subject
        SELECT @CurrentSubjectID = SubjectID
        FROM SubjectAllotments
        WHERE StudentID = @StudentID AND Is_Valid = 1;

        IF @CurrentSubjectID IS NOT NULL
        BEGIN
            IF @CurrentSubjectID <> @RequestedSubjectID
            BEGIN

                UPDATE SubjectAllotments
                SET Is_Valid = 0
                WHERE StudentID = @StudentID AND Is_Valid = 1;

                -- Inserting the new requested subject as valid
                INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
                VALUES (@StudentID, @RequestedSubjectID, 1);
            END
        END
        ELSE
        BEGIN
            -- If no active subject exists, inserting the requested subject as valid
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
            VALUES (@StudentID, @RequestedSubjectID, 1);
        END

        FETCH NEXT FROM request_cursor INTO @StudentID, @RequestedSubjectID;
    END

    CLOSE request_cursor;
    DEALLOCATE request_cursor;

    -- Clearing the SubjectRequest table after processing
    TRUNCATE TABLE SubjectRequest;
END;
GO


---------------------------------------------------


-- Step 4: Executing the Stored Procedure

EXEC ProcessSubjectRequest;


---------------------------------------------------


-- Step 5 : Verification

SELECT * FROM SubjectAllotments;