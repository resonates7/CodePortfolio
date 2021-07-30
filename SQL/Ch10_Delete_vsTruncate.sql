/*


DELETE vs. TRUNCATE (Page 364). 

This practice helps you realize the significant performance difference between the 
DELETE and TRUNCATE statements. Use your knowledge of cross joins, the SELECT INTO statement, and the 
DELETE and TRUNCATE statements to observe the performance difference between fully logged versus minimally 
logged deletions. 

■ Practice 1 The first task in the performance test you’re about to run is to prepare sample data. You use 
the SELECT INTO statement for this purpose. Remember that in order for the SELECT INTO statement to benefit from 
minimal logging, you need to set the recovery model of the database to simple or bulk logged. You need to create 
a test table and fill it with enough data for the performance test. A few million rows should be sufficient. To 
achieve this, you can perform a cross join between one of the tables in the sample database TSQL2012 (for example, 
Sales.Orders) and the table dbo. Nums. You can use a filter against the Nums.n column to control the number of rows 
to generate in the result. If you filter n <= 2000, you get 2000 copies of the other table in the join. Use the 
SELECT INTO statement to create the target table and populate it with the result of the query. 

■ Practice 2 
Delete all rows from the target table by using the DELETE statement and take note of how long it took the statement to finish. 


■ Practice 3 Recreate the sample data. Then use the TRUNCATE statement to delete all rows from the target table. Compare 
the performance of the two methods.


*/

USE TSQL2012;
GO

/* ANALYSIS

SELECT count(*) AS cnt_nums FROM dbo.Nums; -- 100k rows in dbo.nums
SELECT count(*) AS cnt_orders FROM Sales.Orders --830 rows in orders

The product of these two tables is 83 million = 830 * 100k. I only want 1MM, so I must limit.
WIll only use 3,000 rows in Nums for 2,490,000 rows in the table to test performance

*/




-- create test table

If OBJECT_ID('Sales.Performance_tbl', 'U') IS NOT NULL
    DROP TABLE Sales.Performance_tbl;

SELECT o.orderid, n.n
INTO Sales.Performance_tbl
FROM Sales.Orders AS O 
    CROSS JOIN dbo.Nums AS N
WHERE n <=3000
;

/* measure performance

Time to execute:
11:21:57 AMStarted executing query at Line 32
Commands completed successfully.
(2490000 rows affected)
Total execution time: 00:00:00.809

*/

DELETE FROM Sales.Performance_tbl
FROM Sales.Performance_tbl
;

/* measure performance

11:24:51 AMStarted executing query at Line 68
(2490000 rows affected)
Total execution time: 00:00:04.081

*/

TRUNCATE TABLE Sales.Performance_tbl;

/* measure performance

11:26:14 AMStarted executing query at Line 80
Commands completed successfully.
Total execution time: 00:00:00.011

** TRUNCATE is much faster by orders of magnitude

*/

-- cleanup database

If OBJECT_ID('Sales.Performance_tbl', 'U') IS NOT NULL
    DROP TABLE Sales.Performance_tbl;