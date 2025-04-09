--(a) a JOIN combining 2 relations.

-- Query 1: Display department names along with their managers' first and last names.
SELECT DEPARTMENT.departmentName as [ Department Name], EMPLOYEE.firstName as [ Manager First Name], EMPLOYEE.lastName as [ Manager Last Name]
FROM DEPARTMENT
JOIN EMPLOYEE ON DEPARTMENT.managerID = EMPLOYEE.employeeID;


-- Query 2: Display product information along with the supplier's name.
SELECT [PRODUCT].productName as [Product Name], [PRODUCT].price, SUPPLIER.firstName as [ Supplier First Name] , SUPPLIER.lastName as [ Supplier Last Name]
FROM [PRODUCT]
JOIN SUPPLIER ON [PRODUCT].supplierID = SUPPLIER.supplierID;


--(b) a JOIN combining 3 relations.

-- Query 1: Display feedback details along with customer and manager names.
SELECT FEEDBACK.feedBackID, FEEDBACK.feedBackSubject, CUSTOMER.firstName AS CustomerFirstName, CUSTOMER.lastName AS CustomerLastName, EMPLOYEE.firstName AS ManagerFirstName, EMPLOYEE.lastName AS ManagerLastName
FROM FEEDBACK
JOIN CUSTOMER ON FEEDBACK.customerID = CUSTOMER.customerID
JOIN MANAGER ON FEEDBACK.resevingManagerID = MANAGER.employeeID
JOIN EMPLOYEE ON EMPLOYEE.employeeID = MANAGER.employeeID;

-- Query 2: Display product information along with warehouse and department details.
SELECT [PRODUCT].productName, [PRODUCT].price, WAREHOUSE.blockLetter, WAREHOUSE.floorNumber, DEPARTMENT.departmentName
FROM [PRODUCT]
JOIN WAREHOUSE ON [PRODUCT].productStockCode = WAREHOUSE.stockCode
JOIN DEPARTMENT ON [PRODUCT].presentingDepartmentNumber = DEPARTMENT.departmentNumber;


--(c) a LEFT OUTER JOIN.

-- Query 1: Display all employees along with their assigned branches, if any.
SELECT EMPLOYEE.firstName, EMPLOYEE.lastName, WORKER.branch
FROM EMPLOYEE
LEFT OUTER JOIN WORKER ON EMPLOYEE.employeeID = WORKER.employeeID;

-- Query 2: Display all customers along with their feedback, if any.
SELECT CUSTOMER.firstName, CUSTOMER.lastName, FEEDBACK.feedBackSubject
FROM CUSTOMER
LEFT OUTER JOIN FEEDBACK ON CUSTOMER.customerID = FEEDBACK.customerID;


--(d)  a RIGHT OUTER JOIN.
-- Query 1: Display all feedback entries along with customer information, showing feedbacks even if they don't have associated customers.
SELECT FEEDBACK.feedBackID, FEEDBACK.feedBackSubject, CUSTOMER.firstName, CUSTOMER.lastName
FROM FEEDBACK
RIGHT OUTER JOIN CUSTOMER ON FEEDBACK.customerID = CUSTOMER.customerID;

-- Query 2: Display all products and their corresponding warehouses. Include products without warehouses and warehouses without products.
SELECT [PRODUCT].productName, [PRODUCT].price, WAREHOUSE.blockLetter, WAREHOUSE.floorNumber
FROM [PRODUCT]
RIGHT OUTER JOIN WAREHOUSE ON [PRODUCT].productStockCode = WAREHOUSE.stockCode;


--(e)  a FULL OUTER JOIN.

-- Query 1: Display all performance ratings along with employee information, showing performance ratings even if they don't have associated employees.
SELECT WORKER.employeeID, EMPLOYEE.firstName, EMPLOYEE.lastName, WORKER.performanceRating
FROM WORKER
FULL OUTER JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID;

-- Query 2: Display all shipping services and their products
SELECT SHIPPING.barcode, [PRODUCT].productName, [SHIPPING SERVICE].shippingCode, [SHIPPING SERVICE].shippingDate, [SHIPPING SERVICE].shippingAdress
FROM SHIPPING
FULL OUTER JOIN [PRODUCT] ON SHIPPING.barcode = [PRODUCT].barcode
FULL OUTER JOIN [SHIPPING SERVICE] ON SHIPPING.shippingCode = [SHIPPING SERVICE].shippingCode;


--(f) a CROSS JOIN.

-- Query 1: Display all possible combinations of employees and departments.
SELECT EMPLOYEE.firstName, EMPLOYEE.lastName, DEPARTMENT.departmentName
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

-- Query 2: Display all possible combinations of products and suppliers.
SELECT [PRODUCT].productName, [PRODUCT].price, SUPPLIER.firstName, SUPPLIER.lastName
FROM [PRODUCT]
CROSS JOIN SUPPLIER;


--(g) a SELF JOIN 

-- Query: Display employees along with their supervisors.
SELECT E1.firstName AS EmployeeFirstName, E1.lastName AS EmployeeLastName, E2.firstName AS SupervisorFirstName, E2.lastName AS SupervisorLastName
FROM WORKER W
JOIN EMPLOYEE E1 ON W.employeeID = E1.employeeID
JOIN EMPLOYEE E2 ON W.supervisorEmployeeID = E2.employeeID;













