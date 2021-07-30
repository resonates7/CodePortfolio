
USE TSQL2012;
GO

-- create table for practice
CREATE TABLE Production.CategoriesTest
(
    categoryid INT NOT NULL IDENTITY
)
;
GO

-- add some columns
ALTER TABLE Production.CategoriesTest
    ADD categorystatus NVARCHAR(15) NOT NULL,
    categoryname NVARCHAR(15) NOT NULL
;
GO

-- populate data to test out Suggested Practice Case
SET IDENTITY_INSERT Production.CategoriesTest ON;
INSERT Production.CategoriesTest (categoryid, categoryname)
    SELECT categoryid, categoryname
    FROM Production.Categories
;
GO
SET IDENTITY_INSERT Production.CategoriesTest OFF;
/*
    THIS FAILED B/C CANNOT INSERT NULLS, WILL CHANGE CATEGORY STATUS TO INSERT DEFAULTS
*/

ALTER TABLE Production.CategoriesTest
    DROP COLUMN categorystatus 
;
GO

ALTER TABLE Production.CategoriesTest
   ADD categorystatus NVARCHAR(15) NOT NULL DEFAULT('N/A')
;
GO

-- retry the insert with updated default value in categorystatus

-- populate data to test out Suggested Practice Case
SET IDENTITY_INSERT Production.CategoriesTest ON;
INSERT Production.CategoriesTest (categoryid, categoryname)
    SELECT categoryid, categoryname
    FROM Production.Categories
;
GO
SET IDENTITY_INSERT Production.CategoriesTest OFF;

--view the data
SELECT * FROM Production.CategoriesTest;

-- my work here is done. clean up database, drop practice table
DROP TABLE Production.CategoriesTest;