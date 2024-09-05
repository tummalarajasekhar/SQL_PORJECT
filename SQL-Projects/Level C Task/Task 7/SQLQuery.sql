-- Step 1: Creating a table to store numbers
CREATE TABLE Numbers (
    num INT
);

-- Inserting numbers from 1 to 1000
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Numbers (num) VALUES (@i);
    SET @i = @i + 1;
END;


-----------------------------------------------


-- Step 2: Identifying prime numbers
WITH PrimeNumbers AS (
    SELECT num
    FROM Numbers
    WHERE num > 1 AND NOT EXISTS (
        SELECT 1 
        FROM Numbers AS Divisors
        WHERE Divisors.num > 1 
          AND Divisors.num < Numbers.num
          AND Numbers.num % Divisors.num = 0
    )
)


-----------------------------------------------


-- Step 3: Formatting the output
SELECT STRING_AGG(CAST(num AS VARCHAR), '&') AS primes
FROM PrimeNumbers;
