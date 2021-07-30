
USE TSQL2012;
GO

-- insert invalid unitprice fails, CHK_Products_unitprice constraint prevents this.
INSERT INTO Production.Products
    (productname, supplierid, categoryid, unitprice, discontinued)
    VALUES(N'Product Test', 1, 1, -10, 0);

--drop the constraint
ALTER TABLE Production.Products
    DROP CONSTRAINT CHK_Products_unitprice
;

-- retry insert, executes sucessfully
INSERT INTO Production.Products
    (productname, supplierid, categoryid, unitprice, discontinued)
    VALUES(N'Product Test', 1, 1, -10, 0);

--view change
SELECT *
FROM Production.Products
WHERE unitprice < 0
;

-- My work here is done. Undo changes ... remove the added row
DELETE FROM Production.Products
    WHERE productname = N'Product Test';
GO

--re-add the check price constraint
ALTER TABLE Production.Products WITH CHECK
    ADD CONSTRAINT CHK_Products_unitprice
    CHECK (unitprice > 0);
GO

--test constraint. make sure this insert fails
-- retry insert, executes sucessfully
INSERT INTO Production.Products
    (productname, supplierid, categoryid, unitprice, discontinued)
    VALUES(N'Product Test', 1, 1, -10, 0);