-- Create a Local Temporary Table by joining EMPLOYEE and WORKER
SELECT EMPLOYEE.employeeID, firstName, lastName, salary, performanceRating
INTO #EmployeeWorkerJoin  
FROM EMPLOYEE 
JOIN WORKER ON EMPLOYEE.employeeID = WORKER.employeeID;

-- Query 1: Display employees with a salary below 20,000 and their performance ratings 
SELECT employeeID, firstName, lastName, salary, performanceRating
FROM #EmployeeWorkerJoin
WHERE salary < 20000;

-- Query 2: Display employees with a performance rating of 9 and above.
SELECT employeeID, firstName, lastName, salary, performanceRating
FROM #EmployeeWorkerJoin
WHERE performanceRating >= 9;

DROP TABLE #EmployeeWorkerJoin;  










