
-- Subqueries

-- Subquery in SELECT 

SELECT EmployeeID, Salary, (SELECT AVG(Salary) FROM EmployeeSalary) AS AllAvgSalary
FROM [SQL Tutorial]..EmployeeSalary

--How to do it with PARTITION BY

SELECT EmployeeID, Salary, AVG(Salary) OVER () As AllAvgSalary
FROM EmployeeSalary

SELECT EmployeeID, Salary, AVG(Salary) OVER () As AllAvgSalary
FROM EmployeeSalary
GROUP BY EmployeeID, Salary
ORDER BY 1,2

-- Subquery in FROM, CTE or temp_table are preferred

SELECT a.EmployeeID, AllAvgSalary 
FROM(SELECT EmployeeID, Salary, AVG(Salary) OVER () As AllAvgSalary
	FROM EmployeeSalary) a

-- Subquery in WHERE

SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID IN (
		SELECT EmployeeID 
		FROM [SQL Tutorial]..EmployeeDemo
		WHERE Age > 30)
		AND
	Salary IN (
		SELECT Salary
		FROM [SQL Tutorial]..EmployeeSalary
		WHERE Salary > 42000)

