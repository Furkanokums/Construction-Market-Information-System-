-- Instead of trigger
--#1 : Create a View to join PRODUCT and CUSTOMER tables
CREATE VIEW vw_ProductCustomerDetails AS
SELECT 
    p.barcode, 
    p.productName, 
    p.price,
	p.purchasedCustomerID,
    c.customerID, 
    c.firstName AS CustomerFirstName, 
    c.lastName AS CustomerLastName, 
    c.phoneNumber AS CustomerPhone
FROM [PRODUCT] AS p
JOIN CUSTOMER AS c ON p.purchasedCustomerID = c.customerID;
GO


--#2 : INSTEAD OF INSERT Trigger for vw_ProductCustomerDetails
CREATE TRIGGER tr_InsteadOfInsert_ProductCustomer
ON vw_ProductCustomerDetails
INSTEAD OF INSERT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM CUSTOMER 
        WHERE customerID = (SELECT customerID FROM inserted))
		BEGIN
			INSERT INTO CUSTOMER (customerID, firstName, lastName, phoneNumber)
			SELECT customerID, CustomerFirstName, CustomerLastName, CustomerPhone
			FROM inserted;
		END
    INSERT INTO [PRODUCT] (barcode, productName, price, purchasedCustomerID)
    SELECT barcode, productName, price, customerID
    FROM inserted;
END;
GO


--#3
--before exec
SELECT *
FROM vw_ProductCustomerDetails

--exec
INSERT INTO vw_ProductCustomerDetails (barcode, productName, price,purchasedCustomerID ,customerID, CustomerFirstName, CustomerLastName, CustomerPhone)
VALUES ('P021', 'NEW PRODUCT', 6000, 16, 16, 'NEW', 'CUSTOMER', '0111-222-3333');

--after exec
SELECT *
FROM vw_ProductCustomerDetails
GO

--#4 : INSTEAD OF DELETE Trigger for vw_ProductCustomerDetails
CREATE TRIGGER tr_InsteadOfDelete_ProductCustomer
ON vw_ProductCustomerDetails
INSTEAD OF DELETE
AS
BEGIN 
    DELETE FROM [PRODUCT]
    WHERE barcode IN (SELECT barcode FROM deleted);

    DELETE FROM CUSTOMER
    WHERE customerID IN (SELECT customerID FROM deleted) 
	AND NOT EXISTS (SELECT 1 FROM [PRODUCT] WHERE purchasedCustomerID = CUSTOMER.customerID);
END;
GO


--#5
--before exec
SELECT *
FROM vw_ProductCustomerDetails

--exec
DELETE FROM vw_ProductCustomerDetails
WHERE barcode = 'P021';

--after exec
SELECT *
FROM vw_ProductCustomerDetails

