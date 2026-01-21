# SQL Logical Order of Query Processing
Below is the general logical order of query processing in SQL. This order explains why, for example, a column alias defined in the `SELECT` clause cannot be used in the `WHERE` clause but can be used in the `ORDER BY` clause.

This order is a specific sequence the database engine follows to produce the desired results, regardless of the physical execution plan chosen by the optimizer.

1. `FROM`: The data is first retrieved from the specified tables.
2. `JOIN`: Tables are joined together based on the join conditions (`ON` clause), creating a virtual table.
3. `WHERE`: The virtual table's rows are filtered based on the conditions specified in the `WHERE` clause. **Aggregate functions cannot be used here.**
4. `GROUP BY`: The filtered rows are grouped into summary rows based on the columns listed.
5. Aggregation: This is why we cannot have aggregation, such as `SUM` or `AVG`, in the `WHERE` clause, because `WHERE` happened 2 steps above! And this is also why we can only filter using aggregation in our next step; `HAVING`
5. `HAVING`: The `HAVING` clause filters the groups created by `GROUP BY` based on conditions that typically involve aggregate functions.
6. `SELECT`: The final data is processed, and specific columns or expressions (including aliases and aggregate calculations) are selected.
7. `DISTINCT`: Duplicate rows are removed from the result set if specified.
8. `ORDER BY`: The final result set is sorted by the specified columns. Column aliases can be used here because the `SELECT` clause has already been processed.
9. `LIMIT` or `TOP`: The final number of rows to be returned is limited to the specified count. 