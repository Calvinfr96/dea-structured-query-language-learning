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
  WHERE table1.department = table2.department -- Correct!
);
-- We don't use GROUP BY here because that clause is typically used with aggregate functions such as SUM, AVG, or COUNT. In this case, we need the highest salary and MAX is not an aggregate function.
-- MAX retrieves the maximum value in a column, it doesn't perform a calculation based on the total value of rows in the column, such as sum, average or total count.
-- You don't use MAX in the main select clause because you're trying to find the details (including salary) of the employee with the max salary in each department.
-- This means you first need to find the max salary per department with a subquery, then use WHERE to compare that to the salary of the employees in the main query.
-- The most you could do by combining MAX and GROUP BY is display the department and highest salary per department, you wouldn't be able to list other employee details.