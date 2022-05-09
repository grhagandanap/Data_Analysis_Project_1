--CTE (Common Table Expression) acts like Sub Query

WITH CTE_Emp AS
(SELECT FirstName, LastName, Gender, Salary
,COUNT(Gender) OVER (Partition By Gender) as TotalGender
,AVG(Salary) OVER (Partition By Gender) as AvgSalary
FROM [SQL Tutorial]..EmployeeSalary s
JOIN [SQL Tutorial]..EmployeeDemo d
	ON s.EmployeeID = d.EmployeeID
WHERE Salary> 40000)

SELECT FirstName, AvgSalary FROM CTE_Emp

-- Temp Tables

CREATE TABLE #temp_Emp (
EmpID INT,
JobTitle VARCHAR(100),
Salary INT)

SELECT * FROM #temp_Emp

INSERT INTO #temp_Emp VALUES
(1001, 'HR', 45000)

INSERT INTO #temp_Emp
SELECT * FROM [SQL Tutorial]..EmployeeSalary

DROP TABLE IF EXISTS #temp_Emp2
CREATE TABLE #temp_Emp2 (
JobTitle VARCHAR(50),
EmployeesPerJob INT,
AvgAge INT,
AvgSalary INT)

INSERT INTO #temp_Emp2
SELECT Jobtitle, COUNT(JobTitle), AVG(Age), AVG(Salary) 
FROM [SQL Tutorial]..EmployeeDemo d
INNER JOIN [SQL Tutorial]..EmployeeSalary s
ON d.EmployeeID = s.EmployeeID
GROUP BY JobTitle

SELECT * FROM #temp_Emp2

-- Stored Procedure

CREATE PROCEDURE TEST
AS 
SELECT * 
FROM [SQL Tutorial]..EmployeeDemo

EXEC TEST

CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE #temp_Emp2 (
JobTitle VARCHAR(50),
EmployeesPerJob INT,
AvgAge INT,
AvgSalary INT)

INSERT INTO #temp_Emp2
SELECT Jobtitle, COUNT(JobTitle), AVG(Age), AVG(Salary) 
FROM [SQL Tutorial]..EmployeeDemo d
INNER JOIN [SQL Tutorial]..EmployeeSalary s
ON d.EmployeeID = s.EmployeeID
GROUP BY JobTitle

SELECT * FROM #temp_Emp2

EXEC Temp_Employee @JobTitle = 'Salesman'