--#1.Clustered index.
--Display the creation of a clustered index on the employeeID column of the SECURITY table.
ALTER TABLE [SECURITY]
DROP CONSTRAINT PK__SECURITY__C134C9A168A425F5

DROP INDEX PK__SECURITY__C134C9A1E57A0775
ON [SECURITY];

CREATE CLUSTERED INDEX ix_SECURITY_employeeID
ON [SECURITY] (employeeID);


--#2.NonClustered index.
--Display the creation of a nonclustered index on the price column of the PRODUCT table.

CREATE NONCLUSTERED INDEX ix_PRODUCT_price
ON [PRODUCT] (price);


--#3.Unique index.
--Display the creation of a unique index on the productName column of the PRODUCT table.
CREATE UNIQUE INDEX ix_PRODUCT_UNIQUE_productName
ON [PRODUCT] (productName);









