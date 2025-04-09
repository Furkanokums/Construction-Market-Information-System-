-- SP 1 : Create a stored procedure to calculate and display the total cost of products purchased by a customer, and demonstrate its usage.
CREATE PROCEDURE usp_CalculateCustomerTotalCost
    @customerID INT,               -- Input: Customer ID
    @totalCost FLOAT OUTPUT        -- Output: Total cost of purchased products
AS
BEGIN
    SET @totalCost = 0;
    SELECT @totalCost = SUM(price)
    FROM [PRODUCT]
    WHERE purchasedCustomerID = @customerID;
    IF @totalCost IS NULL
    BEGIN
        SET @totalCost = 0;
    END
END;
GO

--example 1
DECLARE @totalCost1 FLOAT;
EXEC usp_CalculateCustomerTotalCost @customerID = 1, @totalCost = @totalCost1 OUTPUT;
PRINT 'Total Cost:' + CAST(@totalCost1 AS NVARCHAR(50));
GO

--example 2
DECLARE @totalCost1 FLOAT;
EXEC usp_CalculateCustomerTotalCost @customerID = 7, @totalCost = @totalCost1 OUTPUT;
PRINT 'Total Cost:' + CAST(@totalCost1 AS NVARCHAR(50));
GO


------------------------------------------------------------------------------------------------------------------


-- SP 2 : Create a stored procedure to update the salary of a worker based on their performance rating, 
--and return the new salary as an output parameter.
CREATE PROCEDURE usp_UpdateWorkerSalary
    @employeeID INT,                -- Input: Employee ID (from WORKER table)
    @newSalary FLOAT OUTPUT -- Output: New salary after the increase
AS
BEGIN
    DECLARE @percentageIncrease FLOAT;

    -- Get the performance rating and current salary by joining EMPLOYEE and WORKER tables
    SELECT @percentageIncrease = 
        CASE 
            WHEN WORKER.performanceRating = 10 THEN 20    -- 20% increase for performance rating 10
            WHEN WORKER.performanceRating > 9 THEN 15     -- 15% increase for performance rating greater than 9
            WHEN WORKER.performanceRating > 8.5 THEN 10   -- 10% increase for performance rating greater than 8.5
            WHEN WORKER.performanceRating > 7.5 THEN 5    -- 5% increase for performance greater than 7.5
            ELSE 0                                        -- 0% increase for performance not greater than 7.5
        END
    FROM WORKER 
    JOIN EMPLOYEE  ON WORKER.employeeID = EMPLOYEE.employeeID
    WHERE WORKER.employeeID = @employeeID;

    -- If the performance rating is valid, update the salary
    IF @percentageIncrease > 0
    BEGIN
        -- Update the worker's salary in the EMPLOYEE table based on the percentage increase
        UPDATE EMPLOYEE
        SET salary = salary * (1 + @percentageIncrease / 100)
        FROM EMPLOYEE 
        JOIN WORKER ON EMPLOYEE.employeeID = WORKER.employeeID
        WHERE EMPLOYEE.employeeID = @employeeID;

        -- Retrieve the updated salary
        SELECT @newSalary = salary
        FROM EMPLOYEE 
        WHERE EMPLOYEE.employeeID = @employeeID;
    END
    ELSE
    BEGIN
        -- If the performance rating is invalid (not found), return the current salary
        SELECT @newSalary = salary
        FROM EMPLOYEE 
        WHERE EMPLOYEE.employeeID = @employeeID;
    END
END;
GO


-- Before exec
select  WORKER.employeeID, EMPLOYEE.firstName, EMPLOYEE. lastName, WORKER.performanceRating, EMPLOYEE.salary 
from WORKER
JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID;

--exec
DECLARE @newSalary FLOAT;
EXEC usp_UpdateWorkerSalary @employeeID = 21, @newSalary = @newSalary OUTPUT;
PRINT @newSalary;

--After Exec
select  WORKER.employeeID, EMPLOYEE.firstName, EMPLOYEE. lastName, WORKER.performanceRating, EMPLOYEE.salary 
from WORKER
JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID;
GO


-------------------------------------------------------------------------------------------------------------------------------------


-- SP 3 : Create a stored procedure to search employees based on optional parameters such as employee ID, first name, last name, gender, email, phone number, salary, date of birth, start shift, and end shift, 
CREATE PROCEDURE usp_searchEmployees
    @employeeID INT = NULL,            
    @firstName NVARCHAR(50) = NULL,    
    @lastName NVARCHAR(50) = NULL,     
    @gender NVARCHAR(50) = NULL,       
    @email NVARCHAR(50) = NULL,        
    @phoneNumber NVARCHAR(50) = NULL,  
    @salary FLOAT = NULL,             
    @dateOfBirth DATE = NULL,         
    @startShift TIME = NULL,           
    @endShift TIME = NULL              
AS
BEGIN
    DECLARE @sSQL NVARCHAR(1000);
    SET @sSQL = 'SELECT * FROM EMPLOYEE WHERE 1=1 ';

    IF @employeeID IS NOT NULL
        SET @sSQL = @sSQL + ' AND employeeID = ' + CAST(@employeeID AS NVARCHAR(5)) + ' ';

    IF @firstName IS NOT NULL
        SET @sSQL = @sSQL + ' AND firstName LIKE ''' + @firstName + '%''';

    IF @lastName IS NOT NULL
        SET @sSQL = @sSQL + ' AND lastName LIKE ''' + @lastName + '%''';

    IF @gender IS NOT NULL
        SET @sSQL = @sSQL + ' AND gender LIKE ''' + @gender + '%''';

    IF @email IS NOT NULL
        SET @sSQL = @sSQL + ' AND email LIKE ''' + @email + '%''';

    IF @phoneNumber IS NOT NULL
        SET @sSQL = @sSQL + ' AND phoneNumber LIKE ''' + @phoneNumber + '%''';

    IF @salary IS NOT NULL
        SET @sSQL = @sSQL + ' AND salary = ' + CAST(@salary AS NVARCHAR(18)) + ' ';

    IF @dateOfBirth IS NOT NULL
        SET @sSQL = @sSQL + ' AND dateOfBirth = ''' + CAST(@dateOfBirth AS NVARCHAR(10)) + '''';

    IF @startShift IS NOT NULL
        SET @sSQL = @sSQL + ' AND startShift = ''' + CAST(@startShift AS NVARCHAR(8)) + '''';

    IF @endShift IS NOT NULL
        SET @sSQL = @sSQL + ' AND endShift = ''' + CAST(@endShift AS NVARCHAR(8)) + '''';

    PRINT @sSQL;
    EXEC(@sSQL);
END;
GO

--examples
--1
EXEC usp_searchEmployees @firstName = 'A';

--2
EXEC usp_searchEmployees @firstName = 'Ayþe';

--3
EXEC usp_searchEmployees @dateOfBirth = '1991-08-25';

--4
EXEC usp_searchEmployees @startShift = '08:00:00';

--5
EXEC usp_searchEmployees @gender = 'male';








DROP PROC usp_searchEmployees

DROP PROC usp_CalculateCustomerTotalCost

DROP PROC usp_UpdateWorkerSalary