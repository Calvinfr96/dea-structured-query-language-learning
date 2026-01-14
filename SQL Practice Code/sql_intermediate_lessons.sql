/*
  Question 1: GROUP BY

  Retrieve the department and the total salary expenses (sum of salaries) as "TotalSalaryExpenses" for each department. Display the results in descending order based on the "TotalSalaryExpenses".
  
  Table: employees
  ColumnNames		DataType		
  employee_id		int		
  first_name		varchar
  last_name		varchar  
  department		varchar 
  salary			decimal
  manager_id		int

  Sample Input:
  employees
  | employee_id | first_name | last_name | department | salary | manager_id |
  |-------------|------------|-----------|------------|--------|------------|
  | 1           | John       | Doe       | Sales      | 65000.00| 3         |
  | 2           | Jane       | Smith     | Finance    | 75000.00| 4         |
  | 3           | Mike       | Johnson   | Sales      | 80000.00| 5         |
  | 4           | Emily      | Davis     | IT         | 70000.00| 5         |
  | 5           | Robert     | Brown     | HR         | 90000.00| NULL      |
  | 6           | Maria      | Garcia    | Finance    | 78000.00| 4         |
  | 7           | Alex       | Lee       | HR         | 85000.00| 5         |
*/

SELECT
  department,
  SUM(salary) AS TotalSalaryExpenses
FROM employees
GROUP BY department
ORDER BY TotalSalaryExpenses DESC; -- Correct!
-- In this question, "for each" is the key phrase indicating you will need to use GROUP BY in the query.
-- Without the GROUP BY Clause, the SUM aggregate function would apply to the entire salary column, returning just one total. This is why it's important to use GROUP BY with aggregate functions.


/*
  Question 2: COUNT OPERATOR

  Retrieve the department and the count of employees as "EmployeeCount" in each department. Display the results in descending order based on the "EmployeeCount".

  Table: employees
  ColumnNames		DataType		
  employee_id		int		
  first_name		varchar
  last_name		varchar  
  department		varchar 
  salary			decimal
  manager_id		int

  Sample Input:
  employees
  | employee_id | first_name | last_name | department | salary | manager_id |
  |-------------|------------|-----------|------------|--------|------------|
  | 1           | John       | Doe       | Sales      | 65000.00| 3         |
  | 2           | Jane       | Smith     | Finance    | 75000.00| 4         |
  | 3           | Mike       | Johnson   | Sales      | 80000.00| 5         |
  | 4           | Emily      | Davis     | IT         | 70000.00| 5         |
  | 5           | Robert     | Brown     | HR         | 90000.00| NULL      |
  | 6           | Maria      | Garcia    | Finance    | 78000.00| 4         |
  | 7           | Alex       | Lee       | HR         | 85000.00| 5         |
*/

SELECT
  department,
  COUNT(*) AS EmployeeCount
FROM employees
GROUP BY department
ORDER BY EmployeeCount DESC; -- Correct!
-- Here, "in each departments" signifies the need for GROUP BY and "count of employees" signifies the need for COUNT.
-- To exclude null values from the count, you could also use a column with unique values, such as the primary key column (employee_id). The above query counts all values, both null and non-null.


/*
  Question 3: SUBQUERIES

  Retrieve employee_id, first_name, last_name and salary who have a higher salary than the average salary across all employees.

  Table: employees
  ColumnNames		DataType		
  employee_id		int		
  first_name		varchar
  last_name		varchar  
  department		varchar 
  salary			decimal
  manager_id		int

  Sample Input:
  employees
  | employee_id | first_name | last_name | department | salary  | manager_id |
  |-------------|------------|-----------|------------|---------|------------|
  | 1           | John       | Doe       | Sales      | 65000.00| 3          |
  | 2           | Jane       | Smith     | Finance    | 75000.00| 4          |
  | 3           | Mike       | Johnson   | Sales      | 80000.00| 5          |
  | 4           | Emily      | Davis     | IT         | 70000.00| 5          |
  | 5           | Robert     | Brown     | HR         | 90000.00| NULL       |
*/

SELECT
  employee_id,
  first_name,
  last_name,
  salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees); -- Correct!


/*
  Question 4: MAX OPERATOR

  Retrieve the employee details (employee_id, first_name, last_name, department, salary) of the employee with the highest salary in each department.

  Table: employees
  ColumnNames		DataType		
  employee_id		int		
  first_name		varchar
  last_name		varchar  
  department		varchar 
  salary			decimal
  manager_id		int

  Sample Input:
  employees
  | employee_id | first_name | last_name | department | salary  | manager_id |
  |-------------|------------|-----------|------------|---------|------------|
  | 1           | John       | Doe       | Sales      | 65000.00| 3          |
  | 2           | Jane       | Smith     | Finance    | 75000.00| 4          |
  | 3           | Mike       | Johnson   | Sales      | 80000.00| 5          |
  | 4           | Emily      | Davis     | IT         | 70000.00| 5          |
  | 5           | Robert     | Brown     | HR         | 90000.00| NULL       |
  | 6           | Maria      | Garcia    | Finance    | 78000.00| 4          |
  | 7           | Alex       | Lee       | HR         | 85000.00| 5          |
*/

SELECT
  employee_id,
  first_name,
  last_name,
  department,
  MAX(salary)
FROM employees
GROUP BY department; -- Incorrect
-- Tried to use GROUP BY in the subquery to obtain the max salary per department.
-- The main query needs to retrieve the requested rows from the employee table for employees with the max department salary.
-- As the main query is assessing rows, it needs to compare the salary of the current employee to that max salary.
-- To retrieve the max department salary, the subquery needs to use the where clause to only include rows where the department
-- from the outer query matches the department from the inner query (they have the same department), then apply MAX(salary) to that subset of data.

SELECT
  employee_id,
  first_name,
  last_name,
  department,
  salary
FROM employees AS table1
WHERE table1.salary = (
  SELECT
    MAX(salary)
  FROM employees as table2
  WHERE table1.department = table2.department -- Solution
);
-- We don't use GROUP BY here because that clause is typically used with aggregate functions such as SUM, AVG, or COUNT. In this case, we need the highest salary and MAX is not an aggregate function.
-- MAX retrieves the maximum value in a column, it doesn't perform a calculation based on the total value of rows in the column, such as sum, average or total count.
-- You don't use MAX in the main select clause because you're trying to find the details (including salary) of the employee with the max salary in each department.
-- This means you first need to find the max salary per department with a subquery, then use WHERE to compare that to the salary of the employees in the main query.
-- The most you could do by combining MAX and GROUP BY is display the department and highest salary per department, you wouldn't be able to list other employee details.
-- With the outer query, we're going row by row and asking, does this employee's salary match the maximum salary for the department (derived from the inner query)? If so, include in the result set.


/*
  Question 5: MIN OPERATOR

  Retrieve the employee details (employee_id, first_name, last_name, department, salary) of the employee with the lowest salary.

  Table: employees
  ColumnNames		DataType		
  employee_id		int		
  first_name		varchar
  last_name		varchar  
  department		varchar 
  salary			decimal
  manager_id		int

  Sample Input:
  employees
  | employee_id | first_name | last_name | department | salary  | manager_id |
  |-------------|------------|-----------|------------|---------|------------|
  | 1           | John       | Doe       | Sales      | 65000.00| 3          |
  | 2           | Jane       | Smith     | Finance    | 75000.00| 4          |
  | 3           | Mike       | Johnson   | Sales      | 80000.00| 5          |
  | 4           | Emily      | Davis     | IT         | 70000.00| 5          |
  | 5           | Robert     | Brown     | HR         | 60000.00| NULL       |
*/

SELECT
  employee_id,
  first_name,
  last_name,
  department,
  salary
FROM employees e1
WHERE salary = (
  SELECT
    MIN(salary)
  FROM employees
); -- Correct!
-- We need to collect the details of the employee with the lowest salary.
-- We can't use GROUP BY because we're not being asked to find the lowest salary within a certain grouping of employees.
-- We could only really use GROUP BY to do that if the question was only asking for the department and associated lowest salary.
-- Because the question asks for non-aggregated columns, we would need to use WHERE with a subquery query.
-- Here, the question just asks for the details of the overall lowest paid employee, so the subquery just needs to find the overall minimum salary.
-- You could also use IN instead of =, but since the subquery only returns one row, it's probably more appropriate to use =.


/*
  Question 6: SUM OPERATOR

  Retrieve the department and the total salary (sum of salaries) as "TotalSalary" for each department. Display the results in descending order based on the total salary expenses.

  Table: employees
  ColumnNames		DataType		
  employee_id		int		
  first_name		varchar
  last_name		varchar  
  department		varchar 
  salary			decimal
  manager_id		int

  Sample Input:
  employees
  | employee_id | first_name | last_name | department | salary  | manager_id |
  |-------------|------------|-----------|------------|---------|------------|
  | 1           | John       | Doe       | Sales      | 65000.00| 3          |
  | 2           | Jane       | Smith     | Finance    | 75000.00| 4          |
  | 3           | Mike       | Johnson   | Sales      | 80000.00| 5          |
  | 4           | Emily      | Davis     | IT         | 70000.00| 5          |
  | 5           | Robert     | Brown     | HR         | 90000.00| NULL       |
  | 6           | Maria      | Garcia    | Finance    | 78000.00| 4          |
  | 7           | Alex       | Lee       | HR         | 85000.00| 5          |
*/

SELECT
  department,
  SUM(salary) AS TotalSalary
FROM employees
GROUP BY department
ORDER BY TotalSalary DESC; -- Correct!

/*
  Question 7: AVG OPERATOR

  Retrieve the year of the order_date as "order_year" along with the average order_amount (average of total amounts) as "AverageOrderAmount" for each year. Display the results in chronological order of the "order_year".

  Table: orders
  ColumnName      DataType
  order_id        int
  order_date      date
  order_amount    decimal
  customer_id     int
  order_status    varchar
  shipping_address   varchar

  Sample Input:
  orders
  | order_id | order_date | order_amount | customer_id | order_status | shipping_address  |
  |----------|------------|--------------|-------------|--------------|-------------------|
  | 1        | 2022-05-15 | 100.00       | 101         | Completed    | Address1          |
  | 2        | 2023-01-20 | 150.00       | 102         | Completed    | Address2          |
  | 3        | 2022-05-15 | 120.00       | 103         | Pending      | Address3          |
  | 4        | 2023-02-10 | 200.00       | 104         | Completed    | Address4          |
  | 5        | 2022-10-05 | 180.00       | 105         | Pending      | Address5          |
  | 6        | 2023-01-20 | 220.00       | 106         | Completed    | Address6          |
  | 7        | 2022-10-05 | 250.00       | 107         | Completed    | Address7          |
*/

SELECT
  YEAR(order_date) AS order_year,
  AVG(order_amount) AS AverageOrderAmount
FROM orders
GROUP BY order_year
ORDER BY order_year ASC; -- Correct!
-- "for each" was the key phrase indicating the need for GROUP BY

/*
  Question 8: HAVING CLAUSE

  Retrieve the department and the average salary (average of salaries) as "AverageSalary" for departments with an average salary greater than 60000. Display the results in descending order based on the "AverageSalary".

  Table: employees
  ColumnNames		DataType		
  employee_id		int		
  first_name		varchar
  last_name		varchar  
  department		varchar 
  salary			decimal
  manager_id		int

  Sample Input:
  employees
  | employee_id | first_name | last_name | department | salary  | manager_id |
  |-------------|------------|-----------|------------|---------|------------|
  | 1           | John       | Doe       | Sales      | 65000.00| 3          |
  | 2           | Jane       | Smith     | Finance    | 75000.00| 4          |
  | 3           | Mike       | Johnson   | Sales      | 80000.00| 5          |
  | 4           | Emily      | Davis     | IT         | 70000.00| 5          |
  | 5           | Robert     | Brown     | HR         | 90000.00| NULL       |
  | 6           | Maria      | Garcia    | Finance    | 78000.00| 4          |
  | 7           | Alex       | Lee       | HR         | 85000.00| 5          |
*/

SELECT
  department,
  AVG(salary) AS AverageSalary
FROM employees
GROUP BY department
HAVING AverageSalary > 60000
ORDER BY AverageSalary DESC; -- Correct!


/*
  Question 9: SUBQUERY WITH AGGREGATED FUNCTIONS

  Retrieve the customer_name of customers who have placed orders with a total amount greater than the average amount of all orders.

  Table: customers
  ColumnName          Datatype           
  customer_id         int 
  customer_name       varchar
  age                 int 
  city                varchar
  email               varchar
  address             varchar

  Table: orders
  ColumnName      DataType
  order_id        int
  order_date      date
  order_amount    decimal
  customer_id     int
  order_status    varchar
  shipping_address   varchar

  Sample Input:
  customers
  | customer_id | customer_name | age | city| email        | address            |
  |-------------|---------------|-----|-----|--------------|--------------------|
  | 101         | Alice         | 30  | NYC | alice@email  | 123 Main Street    |
  | 102         | Bob           | 35  | LA  | bob@email    | 456 Oak Avenue     |
  | 103         | Charlie       | 28  | SF  | charlie@email| 789 Pine Boulevard |
  | 104         | David         | 40  | NYC | david@email  | 101 Elm Lane       |
  | 105         | Emily         | 25  | LA  | emily@email  | 202 Maple Street   |

  orders
  | order_id | order_date | order_amount | customer_id | order_status | shipping_address  |
  |----------|------------|--------------|-------------|--------------|-------------------|
  | 1        | 2023-03-15 | 100.00       | 101         | Pending      | 123 Main Street   |
  | 2        | 2023-05-20 | 150.00       | 102         | Completed    | 456 Oak Avenue    |
  | 3        | 2023-02-10 | 200.00       | 103         | Shipped      | 789 Pine Boulevard|
  | 4        | 2023-06-25 | 80.00        | 104         | Pending      | 101 Elm Lane      |
  | 5        | 2023-04-05 | 120.00       | 105         | Completed    | 202 Maple Street  |
*/

-- Unable to come up with solution =(

SELECT
  customer_name
FROM customers
WHERE customer_id IN (
  SELECT
    customer_id
  FROM orders
  GROUP BY customer_id
  HAVING
    SUM(order_amount) > (
      SELECT
        AVG(order_amount)
      FROM orders
    )
); -- Solution
-- In the main query, we're getting customer_name from the customers table.
-- In the first subquery, we're retrieving a list of customer IDs from the orders table (to be evaluated by the IN operator).
-- This list is produced by grouping the rows in the orders table by customer ID, then eliminating groups (customer IDs) where the total order amount is less than average order amount of all orders.
-- The second subquery is what determines the average order amount amongst all orders.
-- Without a HAVING clause in the first subquery, it would simply return a list of unique customer IDs.



/*
Question 10: CASE STATEMENT
*/