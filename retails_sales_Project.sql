CREATE DATABASE store;

use store;

SELECT * FROM sales_store

-- CREATING A COPY OF THE ORIGINAL DATASET 
SELECT * INTO sales FROM sales_store

SELECT * FROM sales

-- STEP 1 : DATA CLEANING 

-- 1. To check for duplicates values 

SELECT transaction_id,COUNT(*) AS CheckforDuplicates
FROM sales
GROUP BY transaction_id
HAVING COUNT(transaction_id) > 1


-- Checking for Duplicates using Window Functions for High Level Details

WITH CTE AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY transaction_id order by transaction_id) as Row_Num
FROM sales)

SELECT * FROM CTE
WHERE Row_Num > 1

-- NOW Checking duplicates record - they are partial or exact duplicates 
WITH CTE AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY transaction_id order by transaction_id) as Row_Num
FROM sales)

SELECT * FROM CTE
WHERE transaction_id IN ('TXN240646','TXN342128','TXN855235','TXN981773')

-- NOW DELETING Duplicate data from the Table 

WITH CTE AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY transaction_id order by transaction_id) as Row_Num
FROM sales)

DELETE FROM CTE
WHERE Row_Num = 2

SELECT * FROM sales

-- STEP 2 : CORRECTION OF HEADER NAMES ( Column Names ) 

EXEC sp_rename'sales.quantiy','quantity','COLUMN'

EXEC sp_rename'sales.prce','price','COLUMN' 

-- STEP 3 : TO CHECK DATATYPE of all the columns

SELECT COLUMN_NAME ,DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales'

-- STEP 4 : TO CHECK FOR NULL VALUES 

-- Checking null count

DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, 
    COUNT(*) AS NullCount 
    FROM ' + QUOTENAME(TABLE_SCHEMA) + '.sales 
    WHERE ' + QUOTENAME(COLUMN_NAME) + ' IS NULL', 
    ' UNION ALL '
)
WITHIN GROUP (ORDER BY COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'sales';

-- Execute the dynamic SQL
EXEC sp_executesql @SQL;



--  STEP 5 : TREATING NULL VALUES 

SELECT *
FROM sales 
WHERE transaction_id IS NULL
OR
customer_id IS NULL
OR
customer_name IS NULL
OR
customer_age IS NULL
OR
gender IS NULL
OR
product_id IS NULL
OR
product_name IS NULL
OR
product_category IS NULL
OR
quantity IS NULL
or
payment_mode is null
or
purchase_date is null
or 
status is null
or 
price is null
or
time_of_purchase is null


-- DELETING Trancsaction_id WHERE it is NULL
DELETE FROM sales
WHERE transaction_id is null

-- Treating NULL VALUES
SELECT *
FROM sales
WHERE customer_id = 'CUST1003'

UPDATE sales
SET customer_age = '35',gender = 'Male'
WHERE transaction_id = 'TXN432798'

-- 
SELECT * FROM sales
WHERE customer_name = 'Ehsaan Ram'

UPDATE sales
SET customer_id = 'CUST9494'
WHERE transaction_id = 'TXN977900'

-- 
SELECT * FROM sales
WHERE customer_name = 'Damini Raju'

UPDATE sales
SET customer_id = 'CUST1401'
WHERE transaction_id = 'TXN985663'

-- STEP 6 : DATA CLEANING FOR GENDER AND PAYMENT_MODE

-- Gender
SELECT distinct gender
FROM sales

UPDATE sales
SET gender  = 'M'
WHERE gender = 'Male'

UPDATE sales
SET gender  = 'F'
WHERE gender = 'Female'

-- Payment_mode
SELECT distinct payment_mode
FROM sales

UPDATE sales
SET payment_mode  = 'Credit Card'
WHERE payment_mode = 'CC'

----- SOLVING BUSINESS INSIGHTS QUESTIONS

-- 1. What are the top 5 most selling products by Quantity.

SELECT TOP 5
product_name,
sum(quantity) as Totalsale
FROM sales
WHERE status = 'delivered'
GROUP BY product_name 
ORDER BY Totalsale DESC

-- Business Problem : We don't know which products are most in demand.

-- Business Impact : Helps priortize stock and boost sales through targeted promotions.


-- 2. Which products are most frequently cancelled ?

SELECT TOP 5
product_name,
count(*) as total_cancelled
FROM sales
WHERE status = 'cancelled'
GROUP BY product_name
ORDER BY total_cancelled DESC

-- Business Problem : Frequent cancellations affect revenue and customer trust.

-- Business Impact : Identify poor - performing products to improve quality or remove from catalog.



-- 3. What time of the day has the highest number of Purchases?

select * from sales
	
	SELECT 
		CASE 
			WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
			WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
			WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
			WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
		END AS time_of_day,
		COUNT(*) AS total_orders
	FROM sales
	GROUP BY 
		CASE 
			WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
			WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
			WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
			WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
		END
ORDER BY total_orders DESC

-- Business Problem : FIND Peak sales times.

-- Business Impact : OPTIMIZE STAFFING,PROMOTIONS,AND SERVER LOADS.



-- 4. WHO ARE THE TOP 5 HIGHEST SPENDING CUSTOMERS ?


SELECT 
	product_category,
	FORMAT(SUM(price*quantity),'C0','en-IN') AS Revenue
FROM sales 
GROUP BY product_category
ORDER BY SUM(price*quantity) DESC

-- BUSINESS PROBLEM : IDENTIFY VIP CUSTOMERS.

-- BUSINESS IMPACT : Personalized offers,loyalty rewards, and retention.



-- 5.  WHICH PRODUCT CATEGORIES GENERATE THE HIGHEST REVENUE ?

SELECT 
product_category,
FORMAT(SUM(price*quantity),'C0','en-IN') AS Revenue
FROM sales
WHERE status = 'delivered'
GROUP BY product_category
ORDER BY Revenue DESC

-- BUSINESS PROBLEM : Identify Top - performing product categories.

--Business Impact: Refine product strategy, supply chain, and promotions.
--allowing the business to invest more in high-margin or high-demand categories.


-- 6. WHAT IS THE RETURN/CANCELLATION RATE PER PRODUCT CATEGORY ?

SELECT * FROM sales
-- Cancellation
SELECT product_category,
	FORMAT(COUNT(CASE WHEN status='cancelled' THEN 1 END)*100.0/COUNT(*),'N3')+' %' AS cancelled_percent
FROM sales 
GROUP BY product_category
ORDER BY cancelled_percent DESC

-- RETURN
SELECT product_category,
	FORMAT(COUNT(CASE WHEN status='returned' THEN 1 END)*100.0/COUNT(*),'N3')+' %' AS returned_percent
FROM sales 
GROUP BY product_category
ORDER BY returned_percent DESC


--Business Problem Solved: Monitor dissatisfaction trends per category.


---Business Impact: Reduce returns, improve product descriptions/expectations.
--Helps identify and fix product or logistics issues.



-- 7. What is the most prefered payment mode ?

SELECT payment_mode,count(payment_mode) as total_count
FROM sales
GROUP BY payment_mode
ORDER BY total_count DESC

--Business Problem Solved: Know which payment options customers prefer.

--Business Impact: Streamline payment processing, prioritize popular modes.


-- 8. How does age group affect purchasing behaviour ?

-- SELECT * FROM sales

-- SELECT MIN(customer_age) ,MAX(customer_age)
-- from sales

SELECT 
	CASE	
		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
		ELSE '51+'
	END AS customer_age,
	FORMAT(SUM(price*quantity),'C0','en-IN') AS total_purchase
FROM sales 
GROUP BY CASE	
		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
		ELSE '51+'
	END
ORDER BY SUM(price*quantity) DESC

--Business Problem Solved: Understand customer demographics.

--Business Impact: Targeted marketing and product recommendations by age group.

-----------------------------------------------------------------------------------------------------------



--🔁 9. What’s the monthly sales trend?

SELECT * FROM sales
--Method 1

SELECT 
	FORMAT(purchase_date,'yyyy-MM') AS Month_Year,
	FORMAT(SUM(price*quantity),'C0','en-IN') AS total_sales,
	SUM(quantity) AS total_quantity
FROM sales 
GROUP BY FORMAT(purchase_date,'yyyy-MM')

--Method 2
SELECT * FROM sales
	
	SELECT 
		--YEAR(purchase_date) AS Years,
		MONTH(purchase_date) AS Months,
		FORMAT(SUM(price*quantity),'C0','en-IN') AS total_sales,
		SUM(quantity) AS total_quantity
FROM sales
GROUP BY MONTH(purchase_date)
ORDER BY Months
--2023	1	₹ 46,28,608
--2024	1	₹ 3,39,442

SELECT(4628608+339442) -- 4968050

--Business Problem: Sales fluctuations go unnoticed.


--Business Impact: Plan inventory and marketing according to seasonal trends.
