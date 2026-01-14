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
- By default, the `COUNT` Function includes null values in its calculation. To exclude null values, you must use a specific column as the argument instead of an asterisk. For example:
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
- A subquery is a query nested within another query, used to retrieve or manipulate data. They can be used in the `SELECT`, `FROM`, `WHERE`, and `HAVING` Clauses.

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

### Question 4: Alternative Solution
- Retrieve the employee details (employee_id, first_name, last_name, department, salary) of the employee with the highest salary in each department.
- Submitted (Correct) Solution:
  ```
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
    WHERE table1.department = table2.department
  );
  ```
- Alternative Solution:
  ```
  SELECT
    employee_id,
    first_name,
    last_name,
    department,
    salary
  FROM employees
  WHERE salary IN (
    SELECT
      MAX(salary)
    FROM employees
    GROUP BY department
  );
  ```
  - Instead using `MAX` within the subquery to calculate the maximum department salary for each row in the main query, we _can_ use the `GROUP BY` to retrieve a list of the highest department salaries. Then, we collect rows from the outer query (with the specified columns) where the salary is included in that list.
  - You _can't_ use `GROUP BY` in the subquery if you're performing a strict equality check, as in the submitted solution. This is because it will return multiple values and you can't equate a single value to a list.
  - You don't use `MAX(salary)` in `SELECT` because the other details won't necessarily be associated with the row that includes the maximum salary.

## MIN OPERATOR
- The SQL `MIN` Function that allows you to retrieve the smallest value in the specified column of a table. It is particularly useful when you need to find the minimum or smallest value of an attribute in a dataset.
- The `MIN` Function is commonly used in conjunction with `SELECT` to perform aggregations and obtain meaningful insights from data.
- The basic syntax of the `MIN` Function is as follows:
  ```
  SELECT MIN(column_name) AS min_value FROM table_name;
  ```
- When applied to a specific column, the `MIN` Function returns the smallest value present in that column. As with the `MAX` Function, it can be used on various data types, such as numeric values, dates, and strings. For example:
  ```
  SELECT MIN(salary) AS min_salary FROM employees;
  ```
  - This query will return the minimum salary of all employees in the table.
- The `MIN` Function can also be used with other SQL functions for more complex data retrieval. For example, it can be used with `GROUP BY` to find the smallest value in each group. For example:
  ```
  SELECT department, MIN(salary) AS min_salary FROM employees GROUP BY department;
  ```
  - This query will return the department and associated minimum salary of each department in the employees table.
  - First employees are grouped by department, then the minimum salary is calculated for employees in each department.
- The `MIN` Function can also be combined with conditional statements, such as `WHERE`, to find the smallest value of a dataset filtered based on specified criteria. For example:
  ```
  SELECT MIN(order_amount) AS smallest_order_amount FROM orders WHERE order_status = 'Completed';
  ```
  - This query finds the smallest order in the orders table. Specifically, the minimum order amount among completed orders.
  - The `WHERE` Clause filters orders by status, then the `MIN` Function aggregates those filtered order amounts and finds the smallest value.

### Handling NULL Values
- Like the `MAX` Function, the `MIN` Function will automatically ignore null values in a column when determining the minimum value. If all values in a column are, `MIN` will return null as well. For example:
  ```
  SELECT MIN(date_joined) AS earliest_join_date FROM employees;
  ```
  - This query finds the earliest join date among all employees who have a valid (non-null) join date.


## SUM OPERATOR
- The SQL `SUM` Function is a powerful tool that allows you to calculate the sum of _numeric_ values in the specified column of a table. The function is particularly useful for performing numerical aggregations on data, such as calculating total sales amounts, total expenses, or determining the sum of scores.
- The `SUM` Function is commonly used with `SELECT` to perform aggregations on data and produce meaning insights.
- The basic syntax of the `SUM` Function is as follows:
  ```
  SELECT SUM(numeric_column) AS sum_result FROM table_name;
  ```
- When applied to a specific _numeric_ column, `SUM` will calculate the sum of values within that column. For example
  ```
  SELECT SUM(sales_amount) AS total_sales FROM sales;
  ```
  - This query calculates the total of all sales amounts in the sales table.
- The `SUM` Function can also be used with conditional statements, such as `WHERE`, to calculate the sum of values that meet certain criteria. For example:
  ```
  SELECT SUM(quantity_sold) AS total_sold_laptops FROM products WHERE product_name = 'Laptop';
  ```
  - This query returns the total quantity sold among products whose name is 'laptop'. In other words, the total number of laptops sold.
- The `SUM` Function can also be used with `GROUP BY` to calculate the sum of values within a group of rows based on a certain column's values. For example:
  ```
  SELECT department, SUM(salary) AS total_salary_expense FROM employees GROUP BY department;
  ```
  - This query will return the department and sum of salaries within each department from the employees table.
  - First the rows are grouped by department. Then, the sum of salaries within each group is calculated and returned.

### Handling NULL Values
- The `SUM` Function automatically ignores null values in a column and only considers non-null values in its calculation. If an entire column is null, the sum will be null as well. For example:
  ```
  SELECT SUM(total_amount) AS total_revenue FROM orders;
  ```
  - This query retrieves the total revenue among orders with a non-null total_amount value.

## AVG OPERATOR
- The SQL `AVG` Function is a powerful tool that allows you to calculate the mean or average of _numeric_ values within a specified column of a table. It is particularly useful when you need to perform numerical aggregations, such as finding the average test score, calculating the average revenue, or calculating the mean salary.
- The `AVG` Function is commonly used with `SELECT` to perform aggregations and gain meaningful insights from data.
- The basic syntax of the `AVG` Function is as follows:
  ```
  SELECT AVG(numeric_column) AS average_result FROM table_name;
  ```
- When applied to a specific column, the function returns the average of all values within that column. For example:
  ```
  SELECT AVG(test_score) AS average_score FROM student_scores;
  ```
  - This query calculates the average score among all student scores.
- The `AVG` Function can also be used with conditional statements, such as `WHERE`, to perform more complex analysis based on specific criteria. For example:
  ```
  SELECT AVG(rating) AS average_rating FROM product_reviews WHERE product_id = 101;
  ```
  - This query returns the average rating among product reviews with a product ID of 101.
- When using `AVG` with `GROUP BY`, the average is calculated for each group, which can be helpful when generating group-level statistics. For example:
  ```
  SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department;
  ```
  - This query returns the department and average salary for each department in the employees table.

### Handling NULL Values
- The `AVG` Function ignores null values by default and only calculates the average among non-null values in a column. If an entire column is null, the returned average will also be null. For example:
  ```
  SELECT AVG(revenue) AS average_revenue FROM sales;
  ```
  - This query returns the average revenue among all sales with a non-null revenue.

## HAVING CLAUSE
- The SQL `HAVING` Clause is a powerful tool that allows you to filter the results of grouped data based on specified conditions. The function is particularly useful when applying filters to aggregated values obtained from `GROUP BY`.
- The main difference between `HAVING` and `WHERE` is that the former works on the level of groups while the latter works on the level of individual rows.
- The `HAVING` Clause is also used in conjunction with other aggregate functions such as `SUM`, `COUNT`, and `AVG` to refine data analysis and gain more precise insights.
- The basic syntax of the `HAVING` Clause is as follows:
  ```
  SELECT column1, column2, ..., aggregate_function(columnX) AS alias FROM table_name GROUP BY column1, column2, ... HAVING condition;
  ```
- The `HAVING` Clause is typically used to filter results obtained by `GROUP BY`. For example:
  ```
  SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department HAVING AVG(salary) > 50000;
  ```
  - This query returns the department and average salary among departments with an average salary greater than 50000
  - First the groups are created, including the department and average salary in each group. Then, the groups are filtered with `HAVING`, excluding groups with an average salary less than or equal to 50000 in the result set.
- The `HAVING` Clause is also used with aggregate functions such as `COUNT`, `SUM`, `AVG`, `MIN`, or `MAX`. This allows you to filter groups based on aggregated values. For example:
  ```
  SELECT product_category, COUNT(*) AS product_count FROM products GROUP BY product_category HAVING COUNT(*) > 100;
  ```
  - This query returns the product category and product count of those categories with more than 100 products.
- The `HAVING` Clause can also be combined with `WHERE` in addition to `GROUP BY` to create complex queries with multiple filters. For example:
  ```
  SELECT department, AVG(salary) AS average_salary FROM employees WHERE is_active = 1 GROUP BY department HAVING AVG(salary) > 50000;
  ```
  - This query will return the department and average salary for those departments containing only active employees with an average salary greater than 50000.
  - First the inactive employees are filtered out. Then the remaining employees are grouped by department and those groups with an average salary less than or equal to 50000 are filtered out.
- `HAVING` can also be used with Logical Operators such as `AND`, `OR`, and `NOT` to create more intricate conditions for filtering grouped data.

### Handling NULL Values
- Use caution when using the `HAVING` Clause with aggregate functions that involve null values. For accurate results, consider using the `COALESCE` or `IFNULL` functions to handle null values appropriately.

## SUBQUERY WITH AGGREGATED FUNCTIONS
- In SQL, using subqueries with aggregate functions provides a powerful way to aggregate data in multiple stages, allowing you to perform complex analyses with step-by-step calculations and comparisons.
- Using subqueries to aggregate data in stages allows you to break down intricate processes into manageable steps, gaining deeper insights and allowing more complex analysis.
- Aggregating data in stages involves breaking down complex calculations into manageable steps. Subqueries help achieve stage-by-stage data manipulation for refined analysis.

### Common Use Cases
- **Cumulative Summation:** Calculating running totals for various groups.
- **Incremental Averages:** Finding the average as new data points are added.
- **Comparative Analysis:** Comparing aggregates between different groups.
- **Stages of Aggregation: Extract, Apply, Combine**
  1. Extract relevant data for each group.
  2. Apply aggregate functions to the extracted groups.
  3. Combine the results or perform further calculations.

### Practice Examples
- Example 1 - Cumulative Sales by Month:
  ```
  SELECT
    month,
    SUM(amount) AS monthly_sales
  FROM (
    SELECT
      DATE_FORMAT(order_date, '%Y-%m') AS month,
      order_amount AS amount
    FROM orders
  ) AS stage1
  GROUP BY month;
  ```
  - Instead of using an actual table with `FROM`, this query uses a subquery, which returns a table based on the conditions specified in the subquery.
  - The subquery returns a table containing "month" and "amount" columns, with rows for every order (no WHERE condition is applied).
  - Then, the main query uses those results, selects the month and total amount from each month, grouping the results by month.
  - Notice how the outer query uses the column aliases from the subquery.
- Example 2 - Incremental Average Rating:
  ```
  SELECT
    rating_date,
    AVG(rating) OVER (ORDER BY rating_date) AS avg_rating
  FROM (
    SELECT
      rating_date,
      AVG(rating) AS rating
    FROM ratings
    GROUP BY rating_date
  ) AS stage1;
  ```
  - Here, the `OVER` Clause allows you to perform aggregations across groups (partitions) of rows without collapsing the rows as `GROUP BY` would. This would be useful, for example, if you wanted to display total category purchases for every item instead of each category.
  - The subquery returns a table with a rating_date column and a rating column containing the average rating for each rating date.
  - The main query takes this table, then forms a table with rating_date and the average rating for each rating date. The average in the main query represents the cumulative average rating (The average in the inner query represents the "rating" (average among multiple ratings) for that day. The cumulative average is the average of those averages, representing the average across _all_ dates).
  - Since there was no partition explicitly defined in the `OVER`Clause, the entire table (subquery result) acts as the default partition.
  - The `OVER` is necessary in the main query because it only calculates the average for rows up to that point.
    - For the first row, it's the just the average rating of the first row from the inner table.
    - For the second row, it's the average rating of the first two rows from the inner table.
    - For the third row, it's the average rating the the first three rows from the inner table, and so on.
    - This is what is meant by _cumulative_ average.
  - Because of the `ORDER BY` specified in the `OVER` Clause, the final output will be in chronological order.
- Example 3 - Comparative Revenue Growth:
  ```
  SELECT
    region,
    revenue_2022,
    revenue_2023,
    (revenue_2023 - revenue_2022) / revenue_2022 AS growth_rate
  FROM (
    SELECT
      region,
      SUM(
        CASE 
          WHEN year = 2022 THEN revenue
        END
      ) AS revenue_2022,
      SUM(
        CASE
          WHEN year = 2023 THEN revenue
        END
      ) AS revenue_2023
    FROM sales
    GROUP BY region
  ) AS stage1;
  ```
  - Here, the `CASE WHEN END` statements act on each row, applying if-then-else logic similar to a Java `switch case` statement.
    - The purpose of these statements in this query is to group revenue in each region by year, then sum each grouping (each statement creates its own group).
  - The inner query creates a table that includes the region, sum of 2022 revenue for that region, and sum of 2023 revenue for that region.
  - The main query takes this table and displays the region, 2022 revenue, 2023 revenue, and growth rate.

### Benefits of Aggregating in Stages
- Complex Analysis: Break down intricate calculations into simpler steps.
- Improved Efficiency: Optimize queries for performance in each stage.
- Granular Control: Gain a deeper understanding of each data manipulation step.

### Best Practices
- Plan your aggregation process step by step before implementing subqueries. This means writing pseudocode.
- Optimize queries for performance by using appropriate indexes.
- Test and validate the results of each stage for accuracy.