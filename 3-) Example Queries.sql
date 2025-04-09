--(a) retrieve all the tuples of a relation. Display all the attribute values.

-- Query 1: Display all attributes of all employees.
SELECT *
FROM EMPLOYEE;

-- Query 2: Display all attributes of all departments.
SELECT *
FROM DEPARTMENT;


--(b) retrieve all the tuples of a relation. Display some but not all attribute values.

-- Query 1: Display employee IDs, first names, and last names of all employees.
SELECT employeeID, firstName, lastName 
FROM EMPLOYEE;

-- Query 2: Display product names and their prices from the product table.
SELECT productName, price 
FROM [PRODUCT];


--(c) retrieve the tuples that satisfy some condition.

-- Query 1: Display all products with a price greater than 30,000.
SELECT * 
FROM [PRODUCT]
WHERE price > 30000;

-- Query 2: Display all departments managed by the manager with ID 8.
SELECT * 
FROM DEPARTMENT 
WHERE managerID = 8;


--(d) retrieve the tuples that satisfy some condition. Query should include the LIKE operator.

-- Query 1: Display all customers whose addressOfCustomer contains 'Konyaaltý'.
SELECT * 
FROM CUSTOMER 
WHERE addressOfCustomer LIKE '%Konyaaltý%'

-- Query 2: Display all employees whose first name starts with 'A'.
SELECT * 
FROM EMPLOYEE 
WHERE firstName LIKE 'A%';


--(e) retrieve the tuples that satisfy some condition. Output should be sorted – sorting on a single attribute.

-- Query 1: Display all employees with a salary greater than 3,0000, sorted by their date of birth.
SELECT * 
FROM EMPLOYEE
WHERE salary > 30000
ORDER BY dateOfBirth;

-- Query 2: Display all products with a price less than 20,000, sorted by product name.
SELECT * 
FROM [PRODUCT]
WHERE price < 20000
ORDER BY productName;


--(f) Retrieve the tuples that satisfy some condition. Output should be sorted – sorting on more than one attribute.

-- Query 1: Display employees with a salary greater than 5000, sorted by salary (descending) and date of birth (ascending).
SELECT * 
FROM EMPLOYEE 
WHERE salary > 25000
ORDER BY salary DESC, dateOfBirth ASC;

-- Query 2: Display products with a price less than 2,000, sorted by price in descending order, and if the price is the same, sorted by product name alphabetically.
SELECT * 
FROM [PRODUCT]
WHERE price < 2000
ORDER BY price DESC, productName;


--(g) Retrieve the first 5 tuples of a relation.

--Query 1 :Display the first 5 “the most earning Employee”
SELECT TOP 5  firstName , lastName , salary
FROM EMPLOYEE
ORDER BY salary DESC;

-- Query 2: Retrieve the first 5 feedback entries sorted by date.
SELECT TOP 5 feedBackID, feedBackSubject, feedBackDate 
FROM FEEDBACK 
ORDER BY feedBackDate ASC;


--(h) retrieve 20% of the tuples of a relation.

-- Query 1: Display 20% of the employees, ordered by dateOfBirth.
SELECT TOP 20 PERCENT * 
FROM EMPLOYEE
ORDER BY dateOfBirth;

-- Query 2: Retrieve 20% of the employees sorted by their startShift time.
SELECT TOP 20 PERCENT * FROM 
EMPLOYEE ORDER BY 
startShift ASC;

--(i) implement a query that groups a relation on a specific attribute, and applies SUM, COUNT, MIN, MAX aggregate functions on each group.

-- Query 1: Display the total, count, minimum, and maximum salaries for each gender.
SELECT gender, SUM(salary) AS TotalSalary, COUNT(employeeID) AS EmployeeCount, MIN(salary) AS MinSalary, MAX(salary) AS MaxSalary
FROM EMPLOYEE
GROUP BY gender;

-- Query 2: Display the total, count, minimum, and maximum prices for products from each supplier.
SELECT supplierID, SUM(price) AS TotalPrice, COUNT(barcode) AS ProductCount, MIN(price) AS MinPrice, MAX(price) AS MaxPrice
FROM PRODUCT
GROUP BY supplierID;

--(j) List all the relations you have created in your database using all three techniques you have learned.
SELECT name FROM sys.objects
WHERE type = 'u'

SELECT name FROM sys.tables

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES















