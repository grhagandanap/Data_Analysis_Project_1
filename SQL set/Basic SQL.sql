-- Select Statement
-- *, Top,Distinct, Count, As, Max, Min, Avg

SELECT *
FROM [SQL Tutorial]..EmployeeDemo

WHERE LastName IN ('Halpert','Scott')

SELECT AVG(Salary) 
FROM EmployeeSalary

SELECT Jobtitle, AVG(Salary) FROM [SQL Tutorial]..EmployeeDemo
INNER JOIN [SQL Tutorial]..EmployeeSalary
USING (EmployeeID)
WHERE JobTitle = 'Salesman'
GROUP BY JobTitle

SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle = 'Salesmaan' THEN Salary + (Salary*0.10)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary*0.05)
	ELSE Salary + (Salary*0.03)
END AS RAISEDSALARY
FROM [SQL Tutorial]..EmployeeDemo
JOIN [SQL Tutorial]..EmployeeSalary
ON EmployeeDemo.EmployeeID = EmployeeSalary.EmployeeID

SELECT FirstName, LastName, Age,
CASE 
	WHEN Age > 30 THEN 'Old'
	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	ELSE 'Baby'
END
FROM [SQL Tutorial]..EmployeeDemo
WHERE AGE IS NOT NULL
ORDER BY Age

SELECT JobTitle, COUNT(JobTitle)
FROM [SQL Tutorial]..EmployeeDemo
JOIN [SQL Tutorial]..EmployeeSalary
ON EmployeeDemo.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1

SELECT * FROM [SQL Tutorial]..EmployeeDemo

UPDATE [SQL Tutorial]..EmployeeDemo
SET EmployeeID = 1012
WHERE Firstname = 'Holly'

UPDATE [SQL Tutorial]..EmployeeDemo
SET Age = 31, Gender = 'Female'
WHERE Firstname = 'Holly'

DELETE FROM [SQL Tutorial]..EmployeeDemo
WHERE EmployeeID = 1005

SELECT FirstName + ' ' + LastName As FullName, Demo.EmployeeID As ID
FROM [SQL Tutorial]..EmployeeDemo As Demo

--Partition By
SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (Partition By Gender) as TotalGender
FROM [SQL Tutorial]..EmployeeSalary s
JOIN [SQL Tutorial]..EmployeeDemo d
	ON s.EmployeeID = d.EmployeeID