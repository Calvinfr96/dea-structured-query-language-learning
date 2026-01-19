# SQL Advanced Lessons

## DATA TYPES
- SQL Data Types play a crucial role in determining how data is stored, manipulated, and retrieved in a database. Each data type serves a specific purpose, ensuring data integrity, optimizing storage, and facilitating query processing.
- SQL Data Types are broadly classified into the following categories:
  - Numeric Types: Integer and Floating Point Numbers (decimals).
  - Character Strings: Variable and Fixed-Length Strings.
  - Date and Time: Dates, Times, and Intervals.
  - Booleans: True or False Values.
  - Binary Data: Storage for binary objects, such as images or files.
  - Miscellaneous: Data Types such as UUID, JSON, XML, etc.
- Common Number Types:
  - INT: Whole numbers.
  - DECIMAL(p, s): Exact number type with defined precision and scale.
    - Ideal for financial and monetary data, **where minor variations are unacceptable**.
    - `DECIMAL(10, 2)` means 10 total digits with 2 after the decimal point.
    - Represented in base 10.
    - No inherent rounding and comparison errors.
    - Can lead to slower performance.
  - FLOAT: Approximate number type for floating-point numbers.
    - Ideal for scientific or measurement-based calculations, **where minor variations are acceptable**.
    - Provides a range of values with a certain number of significant figures. **Cannot represent decimal values exactly**.
    - Represented in base 2.
    - Prone to minor rounding and comparison errors.
    - Provides better performance when compared to decimal.
- Common String Types:
  - `CHAR(n)`: Fixed-length character string with defined length.
  - `VARCHAR(n)`: Variable-length character string with maximum length.
- Common Date and Time Types:
  - `DATE`: Stores dates (year, month, day). Example: `DATE` represents 'YYYY-MM-DD'.
  - `TIME`: Represents time of day. Example: `TIME` or `TIME(0)` represents 'hh:mm:ss' and `TIME(3)` represents 'hh:mm:ss.nnn'.
  - `TIMESTAMP`: Stores date and time. Example: `TIMESTAMP` represents 'YYYY-MM-DD HH:MM:SS'.
- Boolean Data Type:
  - `BOOLEAN`: Represents true or false values.
- Binary Data Type:
  - `BLOB`: Stores binary large objects, such as images and documents.
- Considerations:
  - Choose data types based on the nature of data and storage requirements.
  - Be mindful of memory consumption and storage efficiency.
  - Maintain data consistency by selecting appropriate data types.
- Advanced Data Types:
  - Data Types such as JSON, XML, and arrays are suitable for more complex data storage needs.

## CONCAT
- The SQL `CONCAT` Function is a powerful tool used to combine two or more strings into a single string. This function is useful for generating composite strings, enhancing data representation, and enriching data manipulation capabilities.
- The basic syntax of the `CONCAT` Function is as follows:
  ```
  CONCAT(string1, string2, ...);
  ```
- Common Use Cases:
  - Data Representation: Creating informative and well-structured text.
  - Displaying Full Names: Combining first, middle, and last names into one string.
  - Generating Custom Messages: Constructing personalized messages.

### Best Practices
- Use `CONCAT` for creating informative and personalized text.
- Test `CONCAT` with various string combinations to achieve the desired output.
- Consider null handling to ensure accurate results.

### Handling NULL Values
- `CONCAT` treats null values as empty strings. To handle null values while using `CONCAT`, use `ISNULL` or `COALESCE`.

### Practice Examples
- Example 1 - Concatenating Names:
  ```
  SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM students;
  ```
  - Combines the first and last names of each student in the students table to generate a full_name column.
  - Uses a string representing a space to separate the two values in the composite string.
- Example 2 - Creating Custom Messages:
  ```
  SELECT CONCAT('Hello, ', first_name, '! Your order #', order_id, ' is confirmed.') AS confirmation_message FROM orders;
  ```
  - Creates a custom confirmation message using a customer's first name and order ID from the orders table.
- Example 3 - Displaying Address:
  ```
  SELECT CONCAT(street_address, ', ', city, ', ', state, ' ', postal_code) AS full_address FROM customers;
  ```
  - Creates a composite full_address string using a customer's street address, city, state, and postal code from the customers table.

## CAST
- The SQL `CAST` Function allows you to convert one data type to another, ensuring compatibility for operations that involve mixed data types. This is particularly useful for performing calculations, comparisons, or aggregations involving data of different types.
- The basic syntax of the `CAST` Function is as follows:
  ```
  SELECT CAST(expression AS target_data_type) AS alias_name;
  ```
- Common Use Cases:
  - Data Type Conversion: Converting data types to perform accurate calculations.
  - Data Presentation: Formatting data for more meaningful presentation.
  - Comparison Operations: Facilitating comparisons between different data types.
  - Aggregations: Ensuring consistency in aggregated results.

### Implicit vs. Explicit Conversion
- **Implicit Conversion:** Some database systems perform automatic type conversions. However performing explicit type conversions using `CAST` provides better control and clarity.
- **Explicit Conversion:** Using `CAST` for intentional data type conversion reduces ambiguity and ensures desired outcomes.
- **Handling Conversion Errors:** `CAST` may fail when attempting to convert one data type to an incompatible data type. Consider using `TRY_CAST` or exception handling to manage potential errors.

### Best Practices
- Specify the target data type explicitly for clarity and control.
- Be cautious when performing type conversions as it may impact query performance.
- Test conversions and validate results to ensure accuracy.

### Practice Examples
- Example 1 - Data Type Conversion:
  ```
  SELECT CAST('123.45' AS DECIMAL(5, 2)) AS converted_value;
  ```
  - Casts a string to a decimal that uses the same precision and scale.
- Example 2 - Comparison of Different Data Types:
  ```
  SELECT product_name, unit_price FROM products WHERE CAST(unit_price AS DECIMAL(8, 2)) > 50.00;
  ```
  - Casts unit price, which might be represented as a string, to a decimal for comparison purposes.
- Example 3 - Presenting Data with CAST:
  ```
  SELECT order_id, CAST(order_date AS DATE) AS formatted_date FROM orders;
  ```

## LENGTH
- The SQL `LENGTH` Function allows you to determine the length (number of characters) of a given string. This is especially useful for assessing the size of text data and making informed decisions based on string length.
  - Spaces are included in the returned character count.
  - Depending on database and character encoding, `LENGTH` might behave differently when used with multibyte characters.
- The basic syntax of the `LENGTH` Function is as follows:
  ```
  LENGTH(string_expression);
  ```
- Common Use Cases:
  - Data Validation: Ensuring text fields meet length requirements.
  - Data Analysis: Assessing the length of textual data.
  - Formatting: Identifying overlong content for formatting adjustments.

### Best Practices
- Utilize `LENGTH` to validate data length effectively.
- Combine `LENGTH` with other functions for sophisticated data analysis.
- Consider the impact of multibyte characters on the result.

### Practice Examples
- Example 1 - Data Validation:
  ```
  SELECT product_name FROM products WHERE LENGTH(product_description) <= 100;
  ```
  - Selects product names for products with a product description of at most 100 characters.
- Example 2 - Data Analysis:
  ```
  SELECT article_title, LENGTH(article_content) AS content_length FROM articles ORDER BY content_length DESC;
  ```
  - Selects the article title and content length from the articles table, ordering the results in descending order based on content length.
  - Content length is calculated by applying `LENGTH` to the article_content field.
- Example 3 - Formatting Adjustment:
```
SELECT CASE WHEN LENGTH(username) > 15 THEN LEFT(username, 15) + '...' ELSE username END AS adjusted_username FROM users;
```
- Selects adjusted user name for users based on the following criteria:
  - Users with usernames greater than 15 characters, the first 15 characters are displayed, followed by '...'.
  - For other users, their username is displayed as-is.

## SUBSTRING
- The SQL `SUBSTRING` Function allows you to extract specific portions of text or character data from a given string. This is especially useful for data manipulation tasks that involve isolating specific information from a larger text.
- The basic syntax of the `SUBSTRING` Function is as follows:
  ```
  SUBSTRING(string_expression, start_position, length);
  ```
  - The start_position parameter indicates where the extraction should begin and based on a 1-based index.
  - The length parameter determines the _maximum_ number of characters to be extracted.
- Common Use Cases:
  - Extracting Names: Retrieve the first or last name from a full name composite string.
  - Data Cleansing: Remove unnecessary characters or spaces.
  - Parsing Information: Separating data with delimiters for easier analysis.
- When handling variable-length text data, you can use `CHARINDEX` to find the index of a delimiter or space within a string dynamically.

### Best Practices
- Consider using the `LENGTH` function to determine the length parameter dynamically.
- Validate the start_position and length parameters to avoid errors.

### Practice Examples
- Example 1 - Extracting First Names:
  ```
  SELECT SUBSTRING(full_name, 1, CHARINDEX(' ', full_name) - 1) AS first_name FROM employees;
  ```
  - Extracts the first name from the full name by dynamically calculating the length of the first name using `CHARINDEX`.
- Example 2 - Removing Prefixes:
  ```
  SELECT SUBSTRING(product_name, 4, LEN(product_name)) AS cleaned_name FROM products;
  ```
  - **Note: The length parameter in the `SUBSTRING` Function indicates the _maximum_ number of characters to extract, starting at the start_position. If the number of remaining characters from this position in the string is less than that length, the function will simply return the rest of the string without throwing an error.**
- Example 3 - Parsing Dates:
  ```
  SELECT SUBSTRING(order_date, 6, 2) AS month FROM orders;
  ```
  - Selects the 6th and 7th characters of the order date. If the order date is formatted correctly, this represents the month.

## CHARINDEX OR SUBSTRING_INDEX
- The SQL `CHARINDEX` Function allows you to determine the position _of the first occurrence_ of a specific substring within a given string. This is very useful for the determining the presence/location of a specific text segment within larger content.
  - If the substring is not found, an index of 0 is returned.
  - `CHARINDEX` is **case-insensitive**. Use `COLLATE` for case-sensitive searches.
- The basic syntax of the `CHARINDEX` Function is as follows:
  ```
  CHARINDEX(substring, string_expression, starting_point);
  ```
  - Returns the **position** of a substring according to a 1-based index.
  - The third parameter is **optional** and allows you to specify a starting point instead of starting from the beginning of the string.
- The basic syntax of the `SUBSTRING_INDEX` function is as follows:
  ```
  SUBSTRING_INDEX(string, delimiter, count);
  ```
  - Returns a **substring** based on a delimiter's occurrence count.
  - The string parameter is the string or text you want to work with.
  - The delimiter parameter is the character or string that marks the split points of the string parameter.
  - The count parameter determines how many times the delimiter should be counted.
    - A positive count returns characters _before_ the nth occurrence from the left.
    - A negative count returns characters _after_ the nth occurrence from the right.
- Common Use Cases:
  - Searching for Keywords: Identifying specific keywords or terms within text data.
  - Validating Data: Ensuring the presence of required information in a dataset.
  - Extracting Information: Using the identified position for data extraction, using a function like `SUBSTRING`.

### Best Practices
- Use `CHARINDEX` to dynamically and efficiently locate substrings.
- Combine `CHARINDEX` with other functions for more complex data analysis.
- Consider handling cases where the substring is not found (0 is returned).

### Practice Examples
- Example 1 - Searching for Keywords:
  ```
  SELECT product_name FROM products WHERE CHARINDEX('premium', product_description) > 0;
  ```
  - Selects the product name for products whose description contains the word premium.
- Example 2 - Validating Data:
  ```
  SELECT order_id FROM orders WHERE CHARINDEX('@', customer_email) > 0;
  ```
  - Selects the ID of orders with a valid email (one that contains the '@' character).
- Example 3 - Extracting Information:
  ```
  SELECT SUBSTRING(
    text_data,
    CHARINDEX('[', text_data) + 1,
    CHARINDEX(']', text_data) - CHARINDEX('[', text_data) - 1
  ) AS extracted_data FROM content;

  SELECT SUBSTRING_INDEX(
    SUBSTRING_INDEX(text_data, '[', -1),
    ']',
    1
  ) AS extracted_data FROM content;
  ```
  - The first query returns the text within the first set of square brackets.
  - The second query returns the text within the last set of square brackets.

## TRIM
- The SQL `TRIM` Function allows you to remove leading or trailing spaces (or other specified characters) from a string. This is especially useful for tasks involving cleaning and formatting data and ensuring data integrity and consistency.
- The basic syntax of the `TRIM` Function is as follows:
  ```
  TRIM([characters FROM] string_expression);
  ```
  - The `FROM` keyword is used to specify the characters you want to remove. For example: `TRIM('.,?!' FROM text)` removes periods, commas, question marks, and exclamation marks from the string expression (it treats each character from the string_expression _individually_).
  - Depending on database and character encoding, `TRIM` might behave differently with multibyte characters.
- Common Use Cases:
  - Data Cleansing: Removing spaces that may cause data inconsistency.
  - Data Formatting: Ensuring consistent formatting of text data.
  - User Input Processing: Removing spaces from user-provided input.

### Best Practices
- Use `TRIM` to ensure consistent data formatting and integrity.
- Use caution when specifying characters to remove to avoid unintended data loss.
- Test the behavior of `TRIM` with multibyte characters if your data involves them.

### Practice Example
- Example 1 - Removing Leading and Trailing Spaces:
  ```
  SELECT TRIM(' ' FROM product_name) AS cleaned_name FROM products;
  ```
  - Removes spaces from the product name in the products table.
- Example 2 - Removing Trailing Characters:
  ```
  SELECT product_id, TRIM(TRAILING ' ' FROM product_name) AS trimmed_product_name, unit_price FROM products;
  ```
  - The `TRAILING` keyword here specifically removes the specified character(' ') from the **trailing** (right) side of the string. Leading spaces and spaces between words remain unaffected.
  - There are also `LEADING` and `BOTH` keywords that can be used to specify removal from the left side and both sides. **In any case, spaces between words are preserved**.
  - Using `TRAILING` is equivalent to using `RTRIM(string)` and using `LEADING` is equivalent to using `LTRIM(string)`.

## LEFT & RIGHT
- The SQL `LEFT` and `RIGHT` Functions allow you to extract a specific number of characters from the beginning (`LEFT`) or ending (`RIGHT`) of a string. This is particularly useful for tasks that involve isolating portions of text data.
- The basic syntax of the `LEFT` Function is as follows:
  ```
  LEFT(string_expression, length);
  ```
- The basic syntax of the `RIGHT` Function is as follows:
  ```
  RIGHT(string_expression, length);
  ```
- In both functions, the length parameter specifies the total number of characters to extract, starting from the beginning or end. The `LENGTH` Function can be used to calculate this parameter dynamically.
- Common Use Cases:
  - Data Extraction: Isolate prefixes or suffixes in text data.
  - Data Analysis: Analyze the beginning or end of text for insights.
  - Formatting: Prepare data for presentation by truncating long text.

### Best Practices
- Use `LEFT` and `RIGHT` to effectively extract relevant data.
- Combine `LEFT` and `RIGHT` with other functions for more sophisticated data manipulation.
- Consider handling cases where the specified length exceeds the actual string length.

### Practice Examples
- Example 1 - Extracting Prefixes:
  ```
  SELECT LEFT(full_name, 10) AS short_name FROM employees;
  ```
- Example 2 - Extracting Suffixes:
  ```
  SELECT RIGHT(product_code, 4) AS last_digits FROM products;
  ```
- Example 3 - Data Presentation:
  ```
  SELECT LEFT(article_content, 100) + '...' AS summarized_content FROM articles;
  ```

## UPPER & LOWER
- The SQL `UPPER` and `LOWER` Functions allow you to convert text to uppercase and lowercase respectively. This is particularly useful for ensuring consistent text formatting. These functions can also be very helpful when performing case-insensitive comparisons.
- The basic syntax of the `UPPER` Function is as follows:
  ```
  UPPER(string_expression);
  ```
- The basic syntax of the `LOWER` Function is as follows:
  ```
  LOWER(string_expression);
  ```
- Common Use Cases:
  - Data Consistency: Ensuring uniform text formatting.
  - Data Analysis: Making case-insensitive comparisons.
  - Display Formatting: Presenting data in a consistent manner.

### Best Practice
- Utilize `UPPER` and `LOWER` for consistent data formatting.
- Use `UPPER` and `LOWER` in comparison queries for accurate results.
- Use caution when applying `UPPER` and `LOWER` to data that will be used for case-sensitive operations.
- **Always store original data, without case modifications, separately for future reference.**

### Practice Examples
- Example 1 - Uppercase Formatting:
  ```
  SELECT UPPER(product_name) AS capitalized_name FROM products;
  ```
- Example 2 - Case-Insensitive Comparison:
  ```
  SELECT product_name FROM products WHERE LOWER(product_name) = 'smartphone';
  ```
- Example 3 - Display Formatting:
  ```
  SELECT CONCAT(UPPER(first_name), ' ', LOWER(last_name)) AS formatted_name FROM customers;
  ```

## EXTRACT
- The SQL `EXTRACT` Function allows you to retrieve specific components (year, month, day, hour, minute, second), as a number, from a given date or time value. This is especially useful for analyzing and manipulating temporal data.
- The basic syntax of the `EXTRACT` Function is as follows:
  ```
  EXTRACT(field FROM source);
  ```
  - Here, the field parameter refers to the part of the date (year, month, day, etc.) and source is the date or time value.
  - Common fields include `YEAR`, `MONTH`, `DAY`, `DAYOFWEEK`, `HOUR`, `MINUTE`, and `SECOND`.
  - Always consider time zone differences when working with Date and Time Functions in SQL. The default time zone for these functions is typically UTC.
- Common Use Cases:
  - Data Analysis: Extracting the year, month, or day for trend analysis.
  - Time Analysis: Retrieving hours or minutes for time-based insights.
  - Date Calculations: Performing calculations using the extracted components.

### Best Practices
- Utilize `EXTRACT` for analyzing and manipulating date and time data.
- Combine `EXTRACT` with other functions to perform more sophisticated analysis.
- Verify data consistency before performing date-based operations.

### Practice Examples
- Example 1 - Extracting Year:
  ```
  SELECT EXTRACT(YEAR FROM order_date) AS order_year FROM orders;
  ```
- Example 1 - Extracting Month:
  ```
  SELECT EXTRACT(MONTH FROM hire_date) AS hire_month FROM employees;
  ```
- Example 3 - Time-based Calculations:
  ```
  SELECT order_id, EXTRACT(HOUR FROM order_time) AS order_hour FROM orders;
  ```

## COALESCE

## SUBQUERY IN CONDITION

## WITH STATEMENTS

## WINDOW FUNCTIONS

## WINDOW FUNCTION WITH AGGREGATE FUNCTION

## ROW NUMBER

## RANK

## LEAD

## LAG