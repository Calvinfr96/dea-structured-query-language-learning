/*
  Question 1: DATA TYPES

  Calculate the number of days between each order_date and '2023-06-01' as "days_since_order". Also display the customer_id, customer_name, order_id and order_date for customers only who have placed orders.

  Table: customers
  ColumnName          Datatype           
  customer_id         int 
  customer_name       varchar
  age                 int 
  city                varchar
  email               varchar
  address           varchar

  Table: orders
  ColumnName      DataType
  order_id        int
  order_date      date
  order_amount    decimal
  customer_id     int
  order_status    varchar
  shipping_address   varchar
*/

SELECT
  c.customer_id,
  c.customer_name,
  o.order_id,
  o.order_date,
  DATEDIFF('2023-06-01', o.order_date) AS days_since_order
FROM customers AS c JOIN orders AS o
ON c.customer_id = o.customer_id; -- Correct!


/*
  Question 2: CONCAT

  Retrieve customer_name, customer_id and customer address as "full address" as a column using address and city combined one after the other.

  Table: customers
  ColumnName          Datatype           
  customer_id         int 
  customer_name       varchar
  age                 int 
  city                varchar
  email               varchar
  address           varchar
*/

SELECT
  customer_id,
  customer_name,
  CONCAT(address, ', ', city) AS "full address"
FROM customers; -- Correct!


/*
  Question 3: CAST

  Calculate total amount for orders with order status = 'Completed' and cast as string with '$' prefix. Display column name as "total_amount_string".

  Table: orders
  ColumnName      DataType
  order_id        int
  order_date      date
  order_amount    decimal
  customer_id     int
  order_status    varchar
  shipping_address   varchar
*/

SELECT
  SUM(order_amount) AS total_amount,
  CAST(total_amount AS CONCAT('$', total_amount))
FROM orders
WHERE order_status = 'Completed'; -- Incorrect

SELECT
  CONCAT('$', CAST(SUM(order_amount) AS CHAR)) AS total_amount_string
FROM orders
WHERE order_status = 'Completed'; -- Correct!
-- Previously thought that they weren't, but nested functions are allowed in SQL.
-- The final result we want is a composite string, so the outermost function should be CONCAT.
-- Next, we need to CAST the total order amount as a CHAR. To get the total, we use SUM within CAST.
-- When using CAST, the data type specified after AS and needs to be a supported SQL data type, not a custom value.


/*
  Question 4: LENGTH

  Retrieve order_id, order_date and order_amount along with customer_name and customer_id where customer name is of odd length for all customers who ordered.

  Table: customers
  ColumnName          Datatype           
  customer_id         int 
  customer_name       varchar
  age                 int 
  city                varchar
  email               varchar
  address           varchar

  Table: orders
  ColumnName      DataType
  order_id        int
  order_date      date
  order_amount    decimal
  customer_id     int
  order_status    varchar
  shipping_address   varchar
*/

SELECT
  c.customer_id,
  c.customer_name,
  o.order_id,
  o.order_date,
  o.order_amount,
FROM customers AS c JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE MOD(LENGTH(customer_name), 2) <> 0; -- Correct!
-- You could also use the % operator as follows: LENGTH(customer_name) % 2 <> 0.


/*
  Question 5: SUBSTRING

  Retrieve the first 5 characters of categories for all products. Display product_id, product_name and a new column with first 5 characters AS first_5_chars. 

  Table: products 
  ColumnName          DataType
  product_id          int
  product_name        varchar 
  category            varchar
  unit_price          decimal
*/

SELECT
  product_id,
  product_name,
  SUBSTRING(category, 1, 5) AS first_5_chars
FROM products; -- Correct!


/*
  Question 6: CHARINDEX OR SUBSTRING_INDEX

  Exercise: Retrieve the customer_name along with their email as "EmailDomain".
  Note: You may use 'SUBSTRING_INDEX' here to solve the question which is MYSQL compatible.

  Table: customers
  ColumnName          Datatype           
  customer_id         int 
  customer_name       varchar
  age                 int 
  city                varchar
  email               varchar
  address           varchar
*/

SELECT
  customer_name,
  SUBSTRING(
    email,
    CHARINDEX('@', email) + 1,
    LENGTH(email)
  )AS email_domain
FROM customers; -- Incorrect

SELECT
  customer_name,
  SUBSTRING_INDEX(email, '@', -1) AS email_domain
FROM customers; -- Solution (CHARINDEX doesn't work in the code editor on the DEA website).
-- If CHARINDEX did work, we could have used SUBSTRING with CHARINDEX to get the email domain as follows:
-- SUBSTRING(email, CHARINDEX('@') + 1, LENGTH(email));


/*
  Question 7: TRIM

  Retrieve customer information including customer_id, customer_name as "FullName", trimming the address as TrimmedAddress and City.

  Table: customers
  ColumnName          Datatype           
  customer_id         int 
  customer_name       varchar
  age                 int 
  city                varchar
  email               varchar
  address           varchar
*/

SELECT
  customer_id,
  customer_name AS FullName,
  TRIM(address) AS TrimmedAddress,
  city
FROM customers; -- Correct!
-- 'TRIM(TRAILING ' ' FROM address) AS TrimmedAddress' also works. The question doesn't specify whether to trim leading, trailing or both.
-- TRIM(string) assumes you want to trim spaces from both ends of the string.


/*
  Question 8: LEFT & RIGHT

  Retrieve three letter short form of all departments starting from first letter as "ShortDeptName", alongside display employee_id and first_name & last_name combined as "FullName".

  Table: employees
  ColumnNames		DataType		
  employee_id		int		
  first_name		varchar
  last_name		varchar  
  department		varchar 
  salary			decimal
  manager_id		int
*/

SELECT
  employee_id,
  CONCAT(first_name, ' ', last_name) AS FullName,
  LEFT(department, 3) AS ShortDeptName
FROM employees; -- Correct!


/*
  Question 9: UPPER & LOWER

  Retrieve product_id, converting product_name to uppercase as "ProductNameUpper", category to lowercase as "CategoryLower".

  Input Format: The products table with the following columns:
  ColumnName          DataType
  product_id          int
  product_name        varchar 
  category            varchar
  unit_price          decimal
*/

SELECT
  product_id,
  UPPER(product_name) AS ProductNameUpper,
  LOWER(category) AS CategoryLower
FROM products; -- Correct!


/*
  Question 10: EXTRACT

  Retrieve all orders displaying order_id, order_status, order_amount and month of order_date as "MonthInWords". Also fetch and display customer_id and customer_name who have ordered.

  Table: customers
  ColumnName          Datatype           
  customer_id         int 
  customer_name       varchar
  age                 int 
  city                varchar
  email               varchar
  address           varchar

  Table: orders
  ColumnName      DataType
  order_id        int
  order_date      date
  order_amount    decimal
  customer_id     int
  order_status    varchar
  shipping_address   varchar
*/

SELECT
  o.order_id,
  o.order_amount,
  MONTHNAME(o.order_date) AS MonthInWords,
  -- DATE_FORMAT(STR_TO_DATE(EXTRACT(MONTH FROM o.order_date), '%m'), '%M') AS MonthInWords, (alternative)
  o.order_status,
  c.customer_id,
  c.customer_name
FROM customers AS c JOIN orders AS o
ON c.customer_id = o.customer_id; -- Correct!
-- We also could have extracted the numerical month from the order_date and used a CASE Statement to get the string month from that.
-- For example: CASE extracted_numerical_month WHEN 1 THEN 'January' END;
-- You could also use the MONTH function to get the numerical month from a date, instead of extract.


/*
Question 11: COALESCE
*/


/*
Question 12: SUBQUERY IN CONDITION
*/


/*
Question 13: WITH STATEMENTS
*/


/*
Question 14: WINDOW FUNCTIONS
*/


/*
Question 15: WINDOW FUNCTION WITH AGGREGATE FUNCTION
*/


/*
Question 16: ROW NUMBER
*/


/*
Question 17: RANK
*/


/*
Question 18: LEAD
*/


/*
Question 19: LAG
*/