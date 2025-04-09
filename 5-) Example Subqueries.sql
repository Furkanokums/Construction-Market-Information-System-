--(a)  a Subquery

-- Query 1: Display employees who earn more than the average salary.
SELECT firstName, lastName, salary
FROM EMPLOYEE
WHERE salary > (SELECT AVG(salary) FROM EMPLOYEE);

-- Query 2: Display products whose price is above the average price.
SELECT productName, price
FROM [PRODUCT]
WHERE price > (SELECT AVG(price) FROM [PRODUCT]);


--(b) a Corelated Subquery
-- Query 1: Display all departments and the number of workers in each department.
SELECT D.departmentNumber, D.departmentName, 
       (SELECT COUNT(*) 
        FROM WORKER W 
        WHERE W.standInDepartmentNumber = D.departmentNumber) AS numberOfEmployees
FROM DEPARTMENT D;

-- Query 2: Display all suppliers and the number of products they supply.
SELECT S.supplierID, S.firstName , S.lastName ,  
       (SELECT COUNT(*) 
        FROM [PRODUCT] P 
        WHERE P.supplierID = S.supplierID) AS numberOfProducts
FROM SUPPLIER S;


--(c) UNION

-- Query 1 :Display first and last names of employees who are younger than 35, as well as all “female” employees. 
SELECT firstName, lastName
FROM EMPLOYEE
WHERE (DATEDIFF(year, dateOfBirth, GETDATE())) < 35
UNION
SELECT firstName, lastName
FROM EMPLOYEE
WHERE gender = 'female'


-- Query 2: Display first and last names of workers working in 'Decoration', as well as the workers with an ‘male’gender.
SELECT firstName, lastName
FROM WORKER
JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID
JOIN DEPARTMENT ON WORKER.standInDepartmentNumber = DEPARTMENT.departmentNumber
WHERE departmentName = 'Decoration'
UNION
SELECT firstName, lastName
FROM WORKER
JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID
WHERE gender = 'male'


--(d) UNION ALL

-- Query 1: Display first and last names of all employees, including both males and females.
SELECT firstName, lastName
FROM EMPLOYEE
WHERE gender = 'male'
UNION ALL
SELECT firstName, lastName
FROM EMPLOYEE
WHERE gender = 'female'

-- Query 2: Display first and last names of all workers, including both permanent and temporary workers.
SELECT firstName, lastName
FROM WORKER
JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID
WHERE workType = 'Permanent'
UNION ALL
SELECT firstName, lastName
FROM WORKER
JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID
WHERE workType = 'Temporary'


--(e) INTERSECT.

-- Query 1: Display first and last names of customers who have purchased products supplied by 'Istikbal'.
SELECT firstName, lastName
FROM CUSTOMER
WHERE customerID IN (
    SELECT purchasedCustomerID
    FROM [PRODUCT]
    WHERE supplierID IN (
        SELECT supplierID
        FROM SUPPLIER
        WHERE supplierCompanyName = 'Istikbal'
    )
)
INTERSECT
SELECT firstName, lastName
FROM CUSTOMER;


-- Query 2: Display product names that have a warranty period of 5 years and have been purchased by a customer.
SELECT productName
FROM [PRODUCT]
WHERE barcode IN (
    SELECT barcode
    FROM [PRODUCT]
    WHERE warrantyPeriod = '5 years'
)
INTERSECT
SELECT productName
FROM [PRODUCT]
WHERE purchasedCustomerID IS NOT NULL;


-- (f) EXCEPT

-- Query 1: Display product names that have a warranty period of 5 years and have not been purchased by any customer.
SELECT productName
FROM [PRODUCT]
WHERE warrantyPeriod = '5 years'
EXCEPT
SELECT productName
FROM [PRODUCT]
WHERE purchasedCustomerID IS NOT NULL;

-- Query 2: Display first and last names of customers who have purchased products but have not provided feedback.
SELECT firstName, lastName
FROM CUSTOMER
WHERE customerID IN (SELECT purchasedCustomerID FROM [PRODUCT])
EXCEPT
SELECT firstName, lastName
FROM CUSTOMER
WHERE customerID IN (SELECT customerID FROM FEEDBACK);


-- (g1) using ISNULL
-- Query 1: Display first and last names of customers, and their addresses with 'Address not available' if the address is NULL.
SELECT firstName, lastName, 
       ISNULL(addressOfCustomer, 'Address not available') AS addressOfCustomer
FROM CUSTOMER;

-- Query 2: Display product details including barcode, product name, price, and presenting department number, with 'Not sold' for products that have not been purchased by any customer.
SELECT barcode, productName, price, 
    ISNULL(CAST(purchasedCustomerID AS nvarchar(50)), 'Not sold') AS purchasedCustomerID ,
	presentingDepartmentNumber
FROM [PRODUCT]


-- (g2) using COALESCE
-- Query 1:  Display details of workers including with 'This worker has no supervisor' for workers without a supervisor.
SELECT WORKER.employeeID, firstName, lastName ,branch, performanceRating, workType, standInDepartmentNumber, 
       COALESCE(CAST(supervisorEmployeeID AS nvarchar(50)) , 'This worker has no supervisor') AS supervisorEmployeeID 
FROM WORKER
JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID

-- Query 2: Display product names and their warranty periods, with 'No specific time specified' if the warranty period is NULL.
SELECT productName, 
		COALESCE(warrantyPeriod, 'No specific time specified') AS warantyPeriod
FROM [PRODUCT];


-- (g3) using CASE

-- Query 1: Display feedback subjects and their ratings, classifying them as 'Excellent', 'Good', 'Average', 'Poor', or 'No Rating'.
SELECT feedBackSubject, rating,
    CASE
		WHEN rating IS NULL THEN CAST('No Rating' AS nvarchar(50))
        WHEN rating >= 4.0 THEN 'Excellent'
        WHEN rating BETWEEN 3.0 AND 3.9 THEN 'Good'
        WHEN rating BETWEEN 2.0 AND 2.9 THEN 'Average'
        WHEN rating < 2.0 THEN 'Poor'
        ELSE CAST(rating AS nvarchar(50))
    END AS [rating info]
FROM FEEDBACK ;

-- Query 2: Display first and last names of employees, and their phone numbers, with 'No Phone' if the phone number is NULL.
SELECT firstName, lastName, 
       CASE 
           WHEN phoneNumber IS NULL THEN 'No Phone'
           ELSE phoneNumber
       END AS phoneNumber
FROM EMPLOYEE;









