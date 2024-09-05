-- Step 1: Creating the STATION Table and Inserting Sample Data
CREATE TABLE STATION (
    ID INT PRIMARY KEY,
    CITY VARCHAR(21),
    STATE CHAR(2),
    LAT_N FLOAT,
    LONG_W FLOAT
);


------------------------------------------------


-- Inserting sample data into the STATION Table
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (1, 'CityA', 'AA', 34.0, 56.0);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (2, 'CityB', 'BB', 22.0, 72.0);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (3, 'CityC', 'CC', 45.0, 54.0);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (4, 'CityD', 'DD', 41.0, 68.0);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (5, 'CityE', 'EE', 30.0, 65.0);


------------------------------------------------


-- Step 2: Query to find the minimum and maximum values of LAT_N and LONG_W
WITH MinMaxValues AS (
    SELECT 
        MIN(LAT_N) AS min_lat_n,
        MAX(LAT_N) AS max_lat_n,
        MIN(LONG_W) AS min_long_w,
        MAX(LONG_W) AS max_long_w
    FROM 
        STATION
)


------------------------------------------------


-- Step 3: Calculating the Manhattan Distance between the points with these coordinates
SELECT 
    ROUND(ABS(min_lat_n - max_lat_n) + ABS(min_long_w - max_long_w), 4) AS manhattan_distance
FROM 
    MinMaxValues;
