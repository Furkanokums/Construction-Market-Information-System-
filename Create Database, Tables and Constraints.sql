--CREATIONS
Create Database  [Construction Market Information]

Use [Construction Market Information]

--EMPLOYEE TABLE
Create Table EMPLOYEE(
employeeID int not null,
firstName nvarchar(50),
lastName nvarchar(50),
gender nvarchar(50),
email nvarchar(50), 
phoneNumber nvarchar(50),
salary float, 
dateOfBirth date,
startShift time, 
endShift time
Primary Key (employeeID)
)


--WORKER TABLE
Create Table WORKER (
employeeID int not null,
branch nvarchar(50),
performanceRating float, 
workType nvarchar(50),
standInDepartmentNumber int, -- FK = From Worker To Department 
supervisorEmployeeID int, -- FK = From Worker To Worker. Self Join
Primary Key(employeeID)
)

--SECURITY TABLE
Create Table [SECURITY] (
employeeID int not null,
securityLocation nvarchar(50),
securityAccessLevel nvarchar(50), 
securitAccessToCCTV nvarchar(50),
Primary Key(employeeID)
)

--MANAGER TABLE
Create Table MANAGER ( 
employeeID int not null,
roomNo nvarchar(50),
graduatingSchool nvarchar(50),
graduatingDepartment nvarchar(50),
Primary Key(employeeID)
)


--DEPARTMENT TABLE
Create Table DEPARTMENT(
departmentNumber int not null,
departmentName nvarchar(50) not null, -- CANDIDATE KEY. Unique Constraint
managerID int, -- FK = From Department to Manager
Primary Key(departmentNumber)
)


--FEEDBACK TABLE
Create Table FEEDBACK(
feedBackID nvarchar(50) not null,
feedBackSubject nvarchar(255),
feedBackDate date,
rating float,
customerID int, -- FK = From Feedback To Customer 
resevingManagerID int, -- FK = From Feedback To Manager
Primary Key(feedBackID)
)


--CUSTOMER TABLE
Create Table CUSTOMER(
customerID int not null,
firstName nvarchar(50),
lastName nvarchar(50),
gender nvarchar(50),
phoneNumber nvarchar(50) not null , -- CANDIDATE KEY. Unique Constraint
addressOfCustomer nvarchar(255),
Primary Key(customerID)
)


--SUPPLIER TABLE
Create Table SUPPLIER(
supplierID int not null,
firstName nvarchar(50),
lastName nvarchar(50),
phoneNumber nvarchar(50) not null, -- CANDIDATE KEY. Unique Constraint
supplierCompanyName nvarchar(50),
Primary Key(supplierID)
)


--WAREHOUSE TABLE
Create Table WAREHOUSE(
stockCode int not null,
blockLetter nvarchar(50),
floorNumber int,
Primary Key(stockCode)
)


--PRODUCT TABLE
Create Table [PRODUCT] (
barcode nvarchar(50) not null,
productName nvarchar(255),
price float,
warrantyPeriod nvarchar(50),
supplierID int, -- FK = From Product To Supplier
productStockCode int, -- FK = From Product To Warehouse
purchasedCustomerID int, -- FK = From Product To Customer. 
presentingDepartmentNumber int, -- FK = From Product To Department
Primary Key(barcode)
)


--SHIPPING SERVICE TABLE
Create Table [SHIPPING SERVICE](
shippingCode int not null,
shippingDate date,
shippingPrice float,
shippingAdress nvarchar(255),
customerID int, -- FK = From Shýpping Service To Customer.
Primary Key(shippingCode)
)


Create TABLE SHIPPING(
shippingCode int not null, -- FK = From Shipping To Shýpping Service .
barcode nvarchar(50) not null, -- FK = From Shýpping To Customer.
Primary Key(shippingCode,barcode)
)




-- PART 2 
-- CONSTRAINTS

--A-) FOREIGN KEY CONSTRAINT

ALTER TABLE WORKER
	ADD CONSTRAINT FK_WorkerEmployeeID_To_Employee
		Foreign Key(employeeID) references
			EMPLOYEE(employeeID)

ALTER TABLE WORKER 
	ADD CONSTRAINT FK_StandInDeptNo_Worker_To_Department
		Foreign Key(standInDepartmentNumber) references
			DEPARTMENT(departmentNumber)

ALTER TABLE WORKER 
	ADD CONSTRAINT FK_SupervisorEmpId_Worker_To_Worker
		Foreign Key(supervisorEmployeeID) references
			WORKER(employeeID)


ALTER TABLE MANAGER
	ADD CONSTRAINT FK_ManagerEmployeeID_To_Employee
		Foreign Key(employeeID) references
			EMPLOYEE(employeeID)


ALTER TABLE [SECURITY]
	ADD CONSTRAINT FK_SecurityEmployeeID_To_Employee
		Foreign Key(employeeID) references
			EMPLOYEE(employeeID)


ALTER TABLE DEPARTMENT 
	ADD CONSTRAINT FK_ManagerID_Department_To_Manager
		Foreign Key(managerID) references
			Manager(employeeID)


ALTER TABLE FEEDBACK
	ADD CONSTRAINT FK_CustomerID_Feedback_To_Customer
		Foreign Key(customerID) references
			CUSTOMER(customerID)

ALTER TABLE FEEDBACK
	ADD CONSTRAINT FK_ManagerID_Feedback_To_Manager
		Foreign Key(resevingManagerID) references
			MANAGER(employeeID)


ALTER TABLE [PRODUCT]
	ADD CONSTRAINT FK_SupplierID_PRODUCT_To_Supplier
		Foreign Key(supplierID) references
			SUPPLIER(supplierID)

ALTER TABLE [PRODUCT]
	ADD CONSTRAINT FK_CustomerID_PRODUCT_To_Customer
		Foreign Key(purchasedCustomerID) references
			CUSTOMER(customerID)

ALTER TABLE [PRODUCT]
	ADD CONSTRAINT FK_StockCode_PRODUCT_To_Warehouse
		Foreign Key(productStockCode) references
			WAREHOUSE(stockCode)

ALTER TABLE [PRODUCT]
	ADD CONSTRAINT FK_DeptNo_PRODUCT_To_Department
		Foreign Key(presentingDepartmentNumber) references
			DEPARTMENT(departmentNumber)


ALTER TABLE [SHIPPING SERVICE]
	ADD CONSTRAINT FK_CustomerID_SHIPPINGSERVICE_To_Customer
		Foreign Key(customerID) references
			CUSTOMER(customerID)


ALTER TABLE SHIPPING
	ADD CONSTRAINT FK_SuppID_SHIPPING_To_SHIPPINGSERVICE
		Foreign Key(shippingCode) references
			[SHIPPING SERVICE](shippingCode)

ALTER TABLE SHIPPING 
	ADD CONSTRAINT FK_barcode_SHIPPING_To_Product
		Foreign Key(barcode) references
			[PRODUCT](barcode)


--B-) UNIQUE, CHECK AND DEFAULT CONSTRAINT

--CHECK
ALTER TABLE EMPLOYEE
	ADD CONSTRAINT CHECK_Employee_Salary
		CHECK (salary>=17002)


ALTER TABLE EMPLOYEE
	ADD CONSTRAINT CHECK_Employee_dateOfBirth 
		CHECK (DATEDIFF(year, dateOfBirth, GETDATE()) BETWEEN 18 AND 65);

--DEFAULT
ALTER TABLE EMPLOYEE
	ADD CONSTRAINT DEFAULT_PRODUCT_Email
		DEFAULT 'not specified' FOR email


ALTER TABLE EMPLOYEE
	ADD CONSTRAINT DEFAULT_EMPLOYEE_Gender 
		DEFAULT 'unknown' FOR gender;


--UNIQUE

ALTER TABLE DEPARTMENT
	ADD CONSTRAINT UNIQUE_Department_DepartmentName
		UNIQUE(departmentName)


ALTER TABLE CUSTOMER
	ADD CONSTRAINT UNIQUE_Customer_PhoneNumber
		UNIQUE(phoneNumber)


ALTER TABLE SUPPLIER
	ADD CONSTRAINT UNIQUE_Supplier_PhoneNumber
		UNIQUE(phoneNumber)
