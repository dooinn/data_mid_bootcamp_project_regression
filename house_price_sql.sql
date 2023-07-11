use house_price_regression;



-- 1. Create a database called `house_price_regression`.



-- 2. Create a table `house_price_data` with the same columns as given in the csv file. Please make sure you use the correct data types for the columns.




-- 3. Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:



-- 4.  Select all the data from table `house_price_data` to check if the data was imported correctly

SELECT * FROM house_price_data;

-- 5.  Use the alter table command to drop the column `date` from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.

ALTER TABLE house_price_data
DROP COLUMN date;




-- 6.  Use sql query to find how many rows of data you have. 
-- Total rows: 21597

SELECT COUNT(*) AS 'Total' FROM house_price_data;



-- 7.  Now we will try to find the unique values in some of the categorical columns:


--     - What are the unique values in the column `bedrooms`? > 1~11 & 33
SELECT DISTINCT(bedrooms) AS bedrooms FROM house_price_data
ORDER BY bedrooms ASC;


--     - What are the unique values in the column `bathrooms`?
SELECT DISTINCT(bathrooms) AS bathrooms FROM house_price_data
ORDER BY bathrooms ASC;


--     - What are the unique values in the column `floors`?

SELECT DISTINCT(floors) AS floors FROM house_price_data
ORDER BY floors ASC;



--     - What are the unique values in the column `condition`? > 1~5
SELECT DISTINCT(`condition`)  FROM house_price_regression.house_price_data
ORDER BY `condition` ASC;


--     - What are the unique values in the column `grade`? > 3~13

SELECT DISTINCT(grade) AS grade FROM house_price_data
ORDER BY grade ASC;



-- 8.  Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
SELECT id FROM house_price_data
ORDER BY price DESC
LIMIT 10;


-- 9.  What is the average price of all the properties in your data? > 540296
SELECT AVG(price) FROM house_price_data;



-- 10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data

--     - What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
SELECT bedrooms, AVG(price) as avg_price FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms ASC;


--     - What is the average `sqft_living` of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the `sqft_living`. Use an alias to change the name of the second column.
SELECT bedrooms, AVG(sqft_living) as avg_sqft_living FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms ASC;



--     - What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and `Average` of the prices. Use an alias to change the name of the second column.

SELECT waterfront, AVG(price) as avg_price FROM house_price_data
GROUP BY waterfront
ORDER BY waterfront ASC;



--     - Is there any correlation between the columns `condition` and `grade`? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.

SELECT 
    (COUNT(*)*SUM(grade*`condition`) - SUM(grade)*SUM(`condition`)) /
    (SQRT(COUNT(*)*SUM(grade*grade) - SUM(grade)*SUM(grade)) * SQRT(COUNT(*)*SUM(`condition`*`condition`) - SUM(`condition`)*SUM(`condition`))) AS correlation_coefficient
FROM 
    house_price_regression.house_price_data;



-- 11. One of the customers is only interested in the following houses:
--     - Number of bedrooms either 3 or 4
--     - Bathrooms more than 3
--     - One Floor
--     - No waterfront
--     - Condition should be 3 at least
--     - Grade should be 5 at least
--     - Price less than 300000

--     For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?

SELECT * FROM house_price_data
WHERE (bedrooms = 3 or 4) && (bathrooms >= 3) && (floors = 1) && (waterfront = 0) && (`condition` >= 3) && (grade >= 5) && (price < 300000);



-- 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.
SELECT * FROM house_price_data
WHERE price >= (SELECT AVG(price)*2 FROM house_price_data);



-- 13. Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW doubled_avg_houses AS
SELECT * 
FROM house_price_data
WHERE price >= (SELECT AVG(price)*2 FROM house_price_data);


-- 14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?

WITH avg_four AS (
SELECT AVG(price) AS four_avg FROM house_price_data
WHERE bedrooms = 4
),
avg_three AS (
SELECT AVG(price) AS three_avg FROM house_price_data
WHERE bedrooms = 3
)
SELECT (four_avg - three_avg) AS price_difference
FROM avg_four, avg_three;






-- 15. What are the different locations where properties are available in your database? (distinct zip codes)

SELECT DISTINCT(zipcode) FROM house_price_data;


-- 16. Show the list of all the properties that were renovated.

SELECT * FROM house_price_data
WHERE yr_renovated > 0;



-- 17. Provide the details of the property that is the 11th most expensive property in your database.

SELECT * FROM house_price_data
ORDER BY price DESC
LIMIT 11;


