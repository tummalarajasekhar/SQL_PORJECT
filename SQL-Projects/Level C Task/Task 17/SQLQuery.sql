-- Step 1: Creating a login at the server level
CREATE LOGIN jaiswalchitransh
WITH PASSWORD = 'Chitransh@123';


------------------------------------------


-- Step 2: Switching to my database
USE celebal;


------------------------------------------


-- Step 3: Creating a user in the database for the login
CREATE USER ExampleUser FOR LOGIN jaiswalchitransh;


------------------------------------------


-- Step 4: Adding the user to the db_owner role
ALTER ROLE db_owner ADD MEMBER ExampleUser;
