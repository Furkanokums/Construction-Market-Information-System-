--#1
-- Create a View to join EMPLOYEE and WORKER tables
CREATE VIEW vw_EmployeeWorkerDetails AS
SELECT 
    e.employeeID, 
    e.firstName, 
    e.lastName, 
    e.salary, 
    w.performanceRating,
	w.employeeID as workerID
FROM EMPLOYEE e
JOIN WORKER w ON e.employeeID = w.employeeID;
GO



-- Query 1: Get employees with salary belov 20,000 and their performance ratings
SELECT employeeID, firstName, lastName, salary, performanceRating
FROM vw_EmployeeWorkerDetails
WHERE salary < 20000;

-- Query 2: Get employees with performance rating 9 and above
SELECT employeeID, firstName, lastName, salary, performanceRating
FROM vw_EmployeeWorkerDetails
WHERE performanceRating >= 9;


-- INSERT
INSERT INTO vw_EmployeeWorkerDetails (employeeID, firstName, lastName, salary,workerID,performanceRating)
VALUES (41, 'New', 'Worker ' , 20000, 41 , 9.0);


DROP View vw_EmployeeWorkerDetails

