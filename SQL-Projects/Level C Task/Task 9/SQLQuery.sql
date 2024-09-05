-- Step 1 : Creating the BST Table
CREATE TABLE BST (
    N INT,
    P INT
);


----------------------------------------------


-- Step 2 : Inserting sample data into the BST Table
INSERT INTO BST (N, P) VALUES (1, 2);
INSERT INTO BST (N, P) VALUES (2, 5);
INSERT INTO BST (N, P) VALUES (3, 2);
INSERT INTO BST (N, P) VALUES (6, 8);
INSERT INTO BST (N, P) VALUES (8, 5);
INSERT INTO BST (N, P) VALUES (9, 8);
INSERT INTO BST (N, P) VALUES (5, NULL);


----------------------------------------------


-- Step 3 : Query to classify each node
WITH NodeTypes AS (
    SELECT
        N,
        CASE
            WHEN P IS NULL THEN 'Root'
            WHEN N NOT IN (SELECT DISTINCT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
            ELSE 'Inner'
        END AS NodeType
    FROM BST
)
SELECT 
    N, 
    NodeType
FROM 
    NodeTypes
ORDER BY 
    N;
