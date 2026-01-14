# SQL Intermediate Lessons

## GROUP BY
- The SQL `GROUP BY` Clause is a tool in SQL that allows you to group rows of data based on the values in one or more columns of a table. This function comes in handy especially when performing aggregate functions on specific groups of data, such as calculating totals, averages, counts, or other statistical measures.
- The `GROUP BY` Clause is commonly used in conjunction with aggregate functions such as `SUM`, `COUNT`, and `AVG`.
- The basic syntax of the `GROUP BY` Clause is as follows:
  ```
  SELECT column1, column2, ..., aggregate_function(columnX) AS alias FROM table_name GROUP BY column1, column2, ...;
  ```
- The `GROUP BY` Clause can be applied to one or more columns, allowing you to group rows with similar values. The columns represent the factors by which rows are being grouped. All factors must be met for a row to be added to a group. For example:
  ```
  SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department;
  ```
  - This query will display the department and employee count of each department in the table.
  - The `GROUP BY` Clause groups employees (rows) by their respective department, the `COUNT(*)` Clause counts the number of employees in each department.
- The `GROUP BY` Clause is typically used in conjunction with aggregate functions such as `COUNT`, `SUM`, `AVG`, `MIN`, or `MAX`. This enables you to calculate aggregated values within each group. For example:
  ```
  SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department;
  ```
  - This query groups employees by department, then calculates and displays the average salary within each department.
- When using `GROUP BY`, be aware that null values are treated as a single group. To exclude null values from grouping, you can use the `WHERE` and `IS NOT NULL` Clauses before applying `GROUP BY`.

### Filtering Data Using the HAVING Clause
- You can further filter grouped data by using a `HAVING` Clause. This clause filters aggregated results, allowing you to include only groups which meet certain criteria and exclude those groups that do not. For example:
  ```
  SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department HAVING AVG(salary) > 50000;
  ```
  - This query groups employees by department, calculates the average salary within each department, and only includes those departments with an average salary greater than 50000 in the result set.

### Combining GROUP BY and ORDER BY
- You can use the `GROUP BY` and `ORDER BY` Clauses to sort grouped data based on specified criteria, making it easier to analyze results. For example:
  ```
  SELECT product_category, COUNT(*) AS product_count FROM products GROUP BY product_category ORDER BY product_count DESC;
  ```
  - This query will display the product count for each product category, sorted by product count in descending order.
  - Note the order of operations here. First, we select the columns to be displayed, applying any aggregate functions and aliases. Then we group rows according to one or more columns. Then we order by one or more columns in ascending or descending order.

## COUNT OPERATOR
- The SQL `COUNT` Function is a powerful tool that allows you to count the number of rows in either a table or group when used in conjunction with the `GROUP BY` Clause. This function can be useful for obtaining insights into the size of datasets, identifying the occurrence of specific conditions, and generating statistical summaries.
- The `COUNT` Function is most commonly used with `SELECT` and `GROUP BY` to perform aggregations and produce meaningful data analyses.
- The basic syntax of the `COUNT` Function is as follows:
  ```
  SELECT COUNT(column_name) AS count_result
  FROM table_name;
  ```
  - Here, count_result acts as an alias for the column that will contain the aggregation.

### Counting Rows in a Table
- The `COUNT` Function can be applied to a single column or using the asterisk (*), which applies the function to all rows in a table. In either case, the function will count the number of rows in the table. For example:
  ```
  SELECT COUNT(*) AS total_records FROM employees;
  ```
  - This query returns the total number of rows (employees) in the table and returns it as 'total_records'.
- You can also use the `COUNT` Function in conjunction with other conditional statements, such as a `WHERE` Clause, to count rows that meet specific criteria. For example:
  ```
  SELECT COUNT(*) AS active_employees FROM employees WHERE is_active = 1;
  ```
  - This query returns the total number of **active** employees in the employees table. Specifically, those with a 'is_active' attribute set to 1. The result is returned as 'active_employees'.
- The `COUNT` Function can also be used in conjunction with the `GROUP BY` Clause to count the numbers of rows within group based on a specific column's values, instead of counting the number of rows in the entire table. This can be useful for generating group-based statistics. For example:
  ```
  SELECT department, COUNT(*) AS employees_count FROM employees GROUP BY department;
  ```
  - This query counts the total number of employees in each department and returns it as 'employee_count'. The number of rows in the result set will depend on the number of _unique_ departments in the table.

### Handling NULL Values
- By default, the `COUNT` Function includes null values in its calculation. To exclude null values you must use a specific column as the argument instead of an asterisk. For example:
  ```
  SELECT COUNT(salary) AS non_null_salaries FROM employees;
  ```
  - This query counts the number of employees with non-null salaries.
  ```
  SELECT COUNT(*) AS any_salary FROM employees;
  ```
  - This query will count all employees, with non and non-null salaries.
  ```
  SELECT COUNT(salary) AS null_salaries FROM employees WHERE salary IS NULL;
  ```
  - This query counts the number of employees without a specified salary.

### Counting Distinct Values
- To count distinct (unique) values within a column, you use the `COUNT` Function with `DISTINCT` as follows: `COUNT(DISTINCT column_name)`. This allows you to obtain unique occurrences within a column. For example:
  ```
  SELECT COUNT(DISTINCT department) AS distinct_departments FROM employees;
  ```
  - This query counts the number of distinct (non-null) departments in the employees table.
- `COUNT(DISTINCT)` can be computationally expensive compared to `COUNT(*)` because the database engine must sort and compare all values to find the unique ones.
- `COUNT(DISTINCT)` can also be applied to multiple columns by specifying all columns in parentheses as follows: `COUNT(DISTINCT (col1, col2))` or `COUNT(DISTINCT CONCAT(col1, col2)))` (syntax varies by database system).

## SUBQUERIES
- Subqueries, also known as nested queries, are a powerful tool in database management that allow you to embed one query within another. They allow you to retrieve data from multiple tables, perform complex calculations, and filter results based on complex conditions.
- A subquery is query nested within another query, used to retrieve or manipulate data. They can be used in the `SELECT`, `FROM`, `WHERE`, and `HAVING` Clauses.

### Types of Subqueries
- **Single Row Subqueries:** Returns a single value (usually used for comparison).
  ```
  SELECT product_name, unit_price FROM products WHERE unit_price > (SELECT AVG(unit_price) FROM products);
  ```
  - Displays the product name and unite price of all products whose unit price is greater than the average unit price of all products.
- **Multiple Row Subqueries:** Returns multiple values (usually used for inclusion in a list).
  ```
  SELECT order_id FROM orders WHERE customer_id IN (SELECT customer_id FROM customers WHERE country = 'USA');
  ```
  - Displays order ID for all US customers (customers with a country of 'USA'). The subquery here is generating a list of US customers.
  - Note: The orders table must have a customer_id column for this query to work correctly. `WHERE customer_id` is being applied to the orders table while `SELECT customer_id` is being applied to the customers table (both tables must have the column).
- **Correlated Subqueries:** Reference values from the outer query within the subquery.
  ```
  SELECT employee_id, first_name, last_name FROM employees e WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);
  ```
  - Displays the employee ID, first name, and last name of employees whose salary is greater than the average salary of employees whose department matches the employee from the outer query. In other words, it displays employees whose salary is greater than the average salary of their own department.
  - Here, `employees e` is functionally equivalent to `employees AS e`. It sets an alias for the 'employees' table as 'e'. This helps shorten the subquery, as you don't have write `employees.department_id`.
  - Although `employees e` works `employees AS` e is cleaner and enhances clarity.
  - In the subquery, `e.department_id` refers to the department of the current employee row being processed by the outer query.
- **Subqueries with `EXISTS`:** Check for the existence of certain conditions.
  ```
  SELECT product_name FROM products WHERE EXISTS (SELECT 1 FROM order_details WHERE product_id = products.product_id);
  ```
  - The outer query selects the names of products from the products table.
  - The subquery checks for the existence (`EXISTS`) of at least one record (`SELECT 1`) in the order_details table that corresponds to each product in the main query (products table).
    - Here, product_id refers to the product ID from the order_details table while `products.products_id` refers to the product ID from the products table in the main query. 
  - Overall, the query returns the names of all products that have been ordered at least once.
  - The `EXISTS` Operator returns true if the subquery returns one or more rows. It's efficient because it stops processing after it finds the first match.
  - By using `SELECT 1`, the query doesn’t need to retrieve actual values from the order_details table, only the existence of rows is sufficient, making it more efficient than `SELECT *` or `SELECT NULL`, which do the same thing in this context. The `SELECT 1` Clause simply indicates that you want to check for the existence of rows (it simply returns a column containing the value '1' for every row that matches the query's conditions). `SELECT 1` is primarily used in conjunction with `EXISTS`.


### Common Use Cases
- Data Filtering: Filtering results based on conditions within another table.
- Aggregations: Using subqueries within aggregate functions such as `SUM` or `AVG`.
- Data Comparison: Comparing values from different datasets.
- Conditional Checks: Checking for the existence of certain records.

### Benefits of Subqueries
- Enhanced Data Retrieval: Retrieve data from multiple tables in a single query.
- Complex Calculations: Perform calculations on multiple levels of data or multiple datasets concurrently.
- Granular Filtering: Filter data based on intricate conditions.

### Best Practices
- Understand the correlation between inner and outer queries when performing correlated subqueries.
- Optimize subqueries for performance by using appropriate indices.

## MAX OPERATOR
- The SQL `MAX` Function is a powerful tool that allows you to retrieve the largest value from a specified column in a table. The function is particularly useful when you need to find the highest value of a given attribute. The function is commonly used in conjunction with the `SELECT` Statement to perform aggregations and obtain meaningful insights from data.
- The basic syntax of the `MAX` Function is as follows:
  ```
  SELECT MAX(column_name) AS max_value FROM table_name;
  ```
- When applied to a specific column, the `MAX` Function returns the largest value in that column. The function can be applied to multiple data types, including numeric values, dates, or strings. For example:
  ```
  SELECT MAX(salary) AS max_salary FROM employees;
  ```
  - This query returns the highest salary of all employees and displays it as 'max_salary'.
- The `MAX` Function is often used with other Functions and Clauses such as `GROUP BY`. When used with `GROUP BY`, it returns the largest value from each group, instead of the entire table. For example:
  ```
  SELECT department, MAX(salary) AS max_salary FROM employees GROUP BY department;
  ```
  - This query returns the maximum salary of any employee in each department. In other words, the highest salary in each department.
- The `MAX` Function can also be combined with conditional statements, such as the `WHERE` Clause, to find the largest value based on specified criteria. For example:
  ```
  SELECT MAX(order_amount) AS largest_order_amount FROM orders WHERE order_status = 'Completed';
  ```
  - This query returns the largest order amount among completed orders, and returns the value as 'largest_order_amount'.

### Handling NULL Values
- The `MAX` Function ignores null values when determining the largest value within a given column. If all values in a specified column are null, the returned maximum value will also be null. For example:
  ```
  SELECT MAX(date_joined) AS latest_join_date FROM employees;
  ```
  - This query returns the most recent join date of any employee in the employees table, excluding any null values.