/*
  Problem 1: Count of Orders

  Write an SQL query to find the total number of orders in the Orders table.

  Tables: orders_prc
  ColumnName		Datatype
  order_id		INT		 
  customer_id		INT
  order_date		DATE
  amount			INT
*/

SELECT
 COUNT(order_id) AS total_orders
FROM orders_prc; -- Correct!
-- We use COUNT here and not SUM because it's asking for the total number of orders.
-- Each row represents one order in this table, so it's best to count a column with a unique value, such as the primary key.
-- Don't forget to assign an alias when performing calculations such as COUNT or SUM in a column.
-- **Always inspect the table(s) for the proper column name spelling. The spelling in the schema might not be correct.**


/*
  Problem 2: Average Salary

  Write an SQL query to find the average salary of all employees in the employees_prc table.

  Tables: employees_prc
  ColumnName		Datatype
  employeeid 		INT
  name 			VARCHAR
  salary 			DECIMAL
*/

SELECT
  AVG(salary) AS average_salary
FROM employees_prc; -- Correct!


/*
  Problem 3: Total Sales

  Write an SQL query to calculate the total quantity of products sold from the sales_prc table.

  Tables: sales_prc
  ColumnName		Datatype
  saleid 			INT
  product 		VARCHAR
  quantitysold 		INT
*/

SELECT
  SUM(quantitysold) AS total_sales
FROM sales_prc; -- Correct!


/*
  Problem 4: Maximum Price

  Write an SQL query to find the product name with the highest price in the products_prc table.

  Tables: products_prc
  ColumnName		Datatype
  productid		INT
  productname 	VARCHAR
  price 			DECIMAL
  category        VARCHAR
  quantityinstock INT
*/

SELECT
  productname,
  price AS highest_price
FROM products_prc
WHERE price = (
  SELECT
    MAX(price)
  FROM products_prc
); -- Correct!
-- Note: We can't directly equate price to MAX(price) (i.e. price = MAX(price)) as that is an invalid use of a group function. We need to use a subquery to find the max price independently.


/*
  Problem 5: Minimum Age

  Write an SQL query to find the minimum age among all customers in the customers_prc table.

  Tables: customers_prc
  ColumnName		Datatype
  customerid 		INT
  name 			VARCHAR
  age 			INT
  city 			VARCHAR
*/

SELECT
  MIN(age) AS minimum_age
FROM customers_prc; -- Correct!


/*
  Problem 6: Distinct Cities

  Write an SQL query to count the number of distinct cities in the customers_prc table.

  Tables: customers_prc
  ColumnName		Datatype
  customerid 		INT
  name 			VARCHAR
  age 			INT
  city 			VARCHAR
*/

SELECT
  COUNT(DISTINCT city) AS number_of_cities
FROM customers_prc; -- Correct!


/*
  Problem 7: Highest Salary in Analytics

  Find the employee with the highest salary in the Analytics department.

  Tables: employee_dimension
  ColumnName			Datatype
  employee_id 			INT
  role 				VARCHAR
  Department 			VARCHAR
  experience_years 		INT
  salary 				INT
  previousyearsalary 		INT
  location 			VARCHAR
*/

SELECT * FROM employee_dimension
WHERE salary = (
  SELECT
    MAX(salary)
  FROM employee_dimension
  GROUP BY Department
  HAVING Department = "Analytics"
); -- Incorrect. This query selects all employees who have a salary that matches the highest in the Analytics department. We only want the Analytics employee with the highest salary.

SELECT * FROM employee_dimension
WHERE salary = (
  SELECT
    MAX(salary)
  FROM employee_dimension
  GROUP BY Department
  HAVING Department = "Analytics"
) AND Department = "Analytics"; -- Correct! 
-- We needed to add 'Department = Analytics to the outside query to filter the results for the outside query.
-- Note: You don't need to use GROUP BY here. You could also just filter the results of the subquery with WHERE before applying MAX:
-- SELECT
--   MAX(salary)
-- FROM employee_dimension
-- WHERE Department = "Analytics";
-- Instead of using GROUP BY with HAVING to get one group, use WHERE instead.


/*
  Problem 8: Ph.D Degree

  Display employee details who holds a Ph.D. degree in Data Science.

  Tables: qualificationandskills
  ColumnName		    Datatype
  employee_id 		int
  education_level 	VARCHAR
  graduation_year 	INT
  field_of_study 		VARCHAR
  technical_skills 	VARCHAR
*/

SELECT * FROM qualificationandskills
WHERE Education_Level = "Ph.D." AND Field_Of_Study = "Data Science"; -- Correct!


/*
  Problem 9: More Years of Experience

  Find out how many employees have experience greater than or equal to 5 years.

  Tables: employee_dimension
  ColumnName		Datatype
  employee_id 		INT
  role 			VARCHAR
  department 		VARCHAR
  experience_years 	INT
  salary 			INT
  previousyearsalary 	INT
  location 		VARCHAR
*/

SELECT
  COUNT(employee_id) AS experienced_employees
FROM employee_dimension
WHERE Experience_Years >= 5; -- Correct!
-- Note: Using COUNT(*) is more performant than using COUNT(employee_id) because the former does not need to perform any NULL checks.


/*
  Problem 10: SQL as Skill

  List employees who have SQL as one of their technical skills.

  Tables: qualificationandskills

  ColumnName		    Datatype
  employee_id 		int
  education_level 	VARCHAR
  graduation_year 	INT
  field_of_study 		VARCHAR
  technical_skills 	VARCHAR
*/

SELECT * FROM qualificationandskills
WHERE Technical_Skills LIKE '%SQL%'; -- Correct!