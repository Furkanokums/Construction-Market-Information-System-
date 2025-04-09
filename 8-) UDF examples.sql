-- FURKAN OKUMUÞ
--STUDENT NO : 220201070

--Homework Assignment #9 PART 1

--UDF1: Scalar-Valued Function

--Create a function to calculate and return the new salary for a worker based on their performance rating.
CREATE FUNCTION udf_CalculateNewSalary( @employeeID INT ) RETURNS FLOAT  
AS
BEGIN
    DECLARE @currentSalary FLOAT;
    DECLARE @percentageIncrease FLOAT;
    SELECT @currentSalary = EMPLOYEE.salary,
           @percentageIncrease = 
               CASE 
                   WHEN WORKER.performanceRating = 10 THEN 20    -- 20% increase for performance rating 10
                   WHEN WORKER.performanceRating > 9 THEN 15     -- 15% increase for performance rating > 9
                   WHEN WORKER.performanceRating > 8.5 THEN 10   -- 10% increase for performance rating > 8.5
                   WHEN WORKER.performanceRating > 7.5 THEN 5    -- 5% increase for performance rating > 7.5
                   ELSE 0                                        -- 0% increase for performance rating < 7.5
               END
    FROM WORKER 
    JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID
    WHERE WORKER.employeeID = @employeeID;

    --Calculate the new salary
    DECLARE @newSalary FLOAT;
    SET @newSalary = @currentSalary * (1 + @percentageIncrease / 100);
    RETURN @newSalary;
END;
GO

--example
SELECT WORKER.employeeID, firstName, lastName, salary, dbo.udf_CalculateNewSalary(21) AS NewSalary
FROM EMPLOYEE
JOIN WORKER ON EMPLOYEE.employeeID = WORKER.employeeID
WHERE WORKER.employeeID = 21;
GO


--UDF2: Inline Table-Valued Function

--Create a table-valued function to return employee details for a given department number.
CREATE FUNCTION udf_GetEmployeesByDepartment(@departmentNumber INT ) RETURNS TABLE  
AS
	RETURN
    SELECT EMPLOYEE.employeeID, firstName, lastName, salary, gender, email
    FROM EMPLOYEE 
    JOIN WORKER ON EMPLOYEE.employeeID = WORKER.employeeID
    WHERE WORKER.standInDepartmentNumber = @departmentNumber;
GO

--example
SELECT * 
FROM dbo.udf_GetEmployeesByDepartment(101);  
GO














