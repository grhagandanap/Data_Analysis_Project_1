
--String function - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

DROP TABLE IF EXISTS EmpError
CREATE TABLE EmpError
(
	EmpID VARCHAR(50),
	FirstName VARCHAR(50),
	LastName VARCHAR(50)
)

INSERT INTO EmpError VALUES
('1001', 'Jimbo', 'Halbert'),
('  1002', 'Pamela', 'Beasely'),
('1005', 'Toby', 'Flenderson - Fired')

SELECT * FROM EmpError

-- Using TRIM, LTRIM, RTRIM

Select EmpID, TRIM (EmpID) as IDTRIM
FROM EmpError

Select EmpID, LTRIM (EmpID) as IDTRIM
FROM EmpError

Select EmpID, RTRIM (EmpID) as IDTRIM
FROM EmpError

-- Using Replace

SELECT Lastname, REPLACE(LastName, '- Fired','') AS LastNameFixed
FROM EmpError

-- Using Substring, Fuzzy matching when we have no identical int data

SELECT SUBSTRING(Firstname,1,2)
FROM EmpError

SELECT d.FirstName, SUBSTRING(d.FirstName,1,3), SUBSTRING(e.FirstName,1,3)
FROM EmpError e
JOIN EmployeeDemo d
ON SUBSTRING(e.FirstName,1,3) = SUBSTRING(d.FirstName,1,3)

-- Using Upper adn Lower

Select FirstName, LOWER(FirstName), UPPER(FirstName)
FROM [SQL Tutorial]..EmpError