USE TSQL2012;
GO
/*
Implement Error Handling Use the TS2012 database to perform the following actions. 
■ Practice 1 Create a transaction to update the TSQL2012 Production.Products table, incrementing the unitprice 
column by 5 for productid = 100. Use THROW with parameters to raise an error if no rows are updated. 
■ Practice 2 Add a TRY/CATCH block to the transaction. 
■ Practice 3 In the CATCH block, report all the error information back to the client by using the error functions, 
roll back the transaction, and re-raise the error using THROW. (Page 464). 
*/


/*
SOLUTION TO PRACTICE 1
*/
-- implement w/ a TRY/CATCH block
DECLARE @PriceUpdateCnt AS INT
SELECT @PriceUpdateCnt = Count(*) 
    FROM Production.Products
    WHERE productid = 100;
--PRINT @PriceUpdateCnt

UPDATE Production.Products
    SET unitprice += 5
    WHERE productid = 100;
IF @PriceUpdateCnt < 1
    THROW 50000, 'Error with unitprice update. Zero rows updated', 0;

/*
SOLUTION TO PRACTICE 2 AND 3
*/
DECLARE @PriceUpdateCnt AS INT
SELECT @PriceUpdateCnt = Count(*) 
    FROM Production.Products
    WHERE productid = 100;
--PRINT @PriceUpdateCnt

BEGIN TRY
    IF @PriceUpdateCnt < 1
    THROW 50000, 'Error with unitprice update. Zero rows updated', 0;
    UPDATE Production.Products
        SET unitprice += 5
        WHERE productid = 100;    
END TRY

BEGIN CATCH
   SELECT ERROR_NUMBER() AS errornumber
   , ERROR_MESSAGE() AS errormessage
   , ERROR_LINE() AS errorline
   , ERROR_SEVERITY() AS errorseverity
   , ERROR_STATE() AS errorstate;
   
   --THROW 50000, 'Error with unitprice update. Zero rows updated', 0;
END CATCH;


/*
CODE TO TEST ABOVE SOLUTIONS
*/

--no product id = 100 exists. I'll add one.
SET IDENTITY_INSERT Production.Products ON;

INSERT INTO Production.Products (productid, productname, supplierid, categoryid, unitprice, discontinued)
    VALUES (100, N'PRODUCT ZYC', 8, 3, 10.00, 0); 

SET IDENTITY_INSERT Production.Products OFF;

SELECT * FROM Production.Products
    WHERE productid = 100;

-- Delete productid 100 to test when no rows updated
DELETE 
FROM Production.Products
WHERE productid = 100;
