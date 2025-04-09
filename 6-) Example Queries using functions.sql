/*(a) query/queries that make use of the following String functions (you need to use all
the functions at least once): ASCII, CHAR, LTRIM, RTRIM, LOWER, UPPER, REVERSE, LEN,
LEFT, RIGHT, CHARINDEX, SUBSTRING, REPLICATE, SPACE, PATINDEX, REPLACE, STUFF.*/

-- Query 1: Display the first letter of employees' first names and the count of employees for each letter, ordered by the first letter.                   
SELECT  CHAR(ASCII(LEFT(firstName, 1))) AS FirstLetter,  COUNT(*) AS EmployeeCount                     
FROM EMPLOYEE
GROUP BY CHAR(ASCII(LEFT(firstName, 1)))                
ORDER BY FirstLetter;                                   


-- Query 2: Display barcode, fully trimmed product name (removing all leading, trailing, and middle spaces), and price.
SELECT barcode, REPLACE(LTRIM(RTRIM(productName)), ' ', '') AS FullyTrimmedProductName, price
FROM [PRODUCT]


-- Query 3: Display the supplier company name in upper case and product name in lower case.
SELECT UPPER(supplierCompanyName) AS CompanyName, LOWER(productName) AS ProductName   
FROM [PRODUCT]
JOIN SUPPLIER ON SUPPLIER.supplierID = [PRODUCT].supplierID;


-- Query 4: Display employee IDs, first names, last names, and a generated employee password by reversing the first name, taking the last two characters, and combining it with the first two characters of the last name in upper case.
SELECT  employeeID, firstName,lastName,
    UPPER(RIGHT(REVERSE(firstName), 2) + LEFT(lastName, 2)) AS EmployeePassword
FROM EMPLOYEE;


-- Query 5: Display first names, last names, email addresses, and the domain name extracted from email addresses for employees.
SELECT  firstName, lastName, email,
    SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS DomainName
FROM EMPLOYEE
WHERE CHARINDEX('@', email) > 0; 


-- Query 6: Display employee IDs padded with leading zeros to ensure a total length of 6 characters.
SELECT REPLICATE('0', 6 - LEN(CAST(employeeID AS VARCHAR))) + CAST(employeeID AS VARCHAR) AS EmployeeID
FROM EMPLOYEE;


-- Query 7: Display employee IDs, first names, last names, and email addresses for employees whose email addresses contain '@gmail.com'.
SELECT employeeID, firstName, lastName, email
FROM EMPLOYEE
WHERE PATINDEX('%@gmail.com%', email) > 0;


-- Query 8: Display phone numbers with dashes replaced by spaces.
SELECT REPLACE(phoneNumber, '-', SPACE(1)) AS PhoneNumber
FROM EMPLOYEE;


-- Query 9: Display employee ID, first name, last name, and supervisor's employee ID using STUFF to add 'Supervisor: ' prefix and 'No Supervisor' when supervisorEmployeeID is NULL
SELECT WORKER.employeeID, firstName, lastName,
       STUFF(ISNULL(CAST(supervisorEmployeeID AS VARCHAR), 'No Supervisor'), 1, 0, 'SupervisorID: ') AS SupervisorInfo
FROM EMPLOYEE
JOIN WORKER ON WORKER.employeeID = EMPLOYEE.employeeID;



/*(b) query/queries that make use of the following Date/Time functions (you need to use
all the functions at least once): ISDATE, DAY, MONTH, YEAR, DATENAME, DATEADD,
DATEDIFF.*/

-- Query 1: Check if dateOfBirth values are valid dates
SELECT dateOfBirth, 
    ISDATE(CAST(dateOfBirth AS nvarchar(50))) AS IsValidDate 
FROM EMPLOYEE;


-- Query 2: Display shipping dates along with the day, month, and year extracted from each shipping date.
SELECT shippingDate, 
    DAY(shippingDate) AS ShippingDay, 
    MONTH(shippingDate) AS ShippingMonth, 
    YEAR(shippingDate) AS ShippingYear 
FROM [SHIPPING SERVICE];


-- Query 3: Display shipping dates along with the month name and day name extracted from each shipping date.
SELECT shippingDate, 
    DATENAME(MONTH, shippingDate) AS MonthName, 
    DATENAME(WEEKDAY, shippingDate) AS DayName 
FROM [SHIPPING SERVICE];


-- Query 4: Display employee IDs, first names, dates of birth, this year's birthday, and days until their birthday for employees whose birthdays are within the next 30 days.
SELECT employeeID,firstName,lastName,dateOfBirth,
    CASE 
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()), dateOfBirth) < GETDATE() 
        THEN DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()) + 1, dateOfBirth)
        ELSE DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()), dateOfBirth)
    END AS NextBirthday,
    DATEDIFF(DAY, GETDATE(), 
        CASE 
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()), dateOfBirth) < GETDATE() 
            THEN DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()) + 1, dateOfBirth)
            ELSE DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()), dateOfBirth)
        END
    ) AS DaysUntilBirthday
FROM EMPLOYEE
WHERE 
    DATEDIFF(DAY, GETDATE(), 
        CASE 
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()), dateOfBirth) < GETDATE() 
            THEN DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()) + 1, dateOfBirth)
            ELSE DATEADD(YEAR, DATEDIFF(YEAR, dateOfBirth, GETDATE()), dateOfBirth)
        END
) BETWEEN 0 AND 30;



/*(c) query/queries that make use of the following Math functions (you need to use all
the functions at least once): ABS, CEILING, FLOOR, POWER, SQUARE, SQRT, RANDOM,
ROUND.*/
-- Query 1: Display barcode, product name, original price, discount amount, discounted price, rounded up and rounded down discounted prices, and a cash purchase bonus (square root of the discounted price) for products with a positive price.
SELECT barcode, productName, price AS OriginalPrice,
    ROUND(price * 0.10, 2) AS DiscountAmount,
    ROUND(price - (price * 0.10), 2) AS DiscountedPrice,
    CEILING(price - (price * 0.10)) AS RoundedUpPrice,
    FLOOR(price - (price * 0.10)) AS RoundedDownPrice,
    -- Bonus amount if the product is purchased in cash (square root of the discounted price)
    ROUND(SQRT(ROUND(price - (price * 0.10), 2)), 2) AS CashPurchaseBonus
FROM [PRODUCT]
WHERE price > 0;


-- Query 2: Display barcode, product name, original price, a random discount rate between 0% and 20%, and the discounted price after applying the random discount for products with a positive price.
SELECT barcode,productName,price AS OriginalPrice,
    ROUND(RAND() * 20, 2) AS RandomDiscountRate,
    ROUND(price - (price * (RAND() * 20) / 100), 2) AS RandomDiscountedPrice
FROM [PRODUCT]
WHERE price > 0;


-- Query 3: Display employee IDs, first names, and last names for employees whose first and last names differ in length by exactly one character.
SELECT employeeID, firstName, lastName
FROM EMPLOYEE
WHERE ABS(LEN(firstName) - LEN(lastName)) = 1;


-- Query 4: Display employee IDs, first names, last names, salaries, and calculated annual bonuses as the rounded value of the square of the salary divided by 100,000.
SELECT  employeeID, firstName,  lastName,  salary,
    ROUND((SQUARE(salary) / 100000),0) AS AnnualBonus
FROM EMPLOYEE;


-- Query 5: Display barcode, product name, current price, and new price after applying a price increase of the product's current price raised to the power of 1.01.
SELECT barcode, productName, price AS CurrentPrice, ROUND(POWER(price, 1.01), 0) AS NewPrice
FROM [PRODUCT];





























