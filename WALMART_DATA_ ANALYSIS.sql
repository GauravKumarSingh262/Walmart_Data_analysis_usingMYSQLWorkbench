create database Walmart;
use walmart;
SELECT * FROM walmart.`walmartsalesdata.csv`;
SELECT Time,
(CASE 
	WHEN `Time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN `Time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening" 
END) AS time_of_day
FROM walmart.`walmartsalesdata.csv`;

ALTER TABLE walmart.`walmartsalesdata.csv` ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmart.`walmartsalesdata.csv` 
SET time_of_day = 
    CASE 
        WHEN TIME(`Time`) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN TIME(`Time`) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;
-- Day_name

SELECT Date,
DAYNAME(Date) AS day_name
FROM walmart.`walmartsalesdata.csv`;

ALTER TABLE walmart.`walmartsalesdata.csv` ADD COLUMN day_name VARCHAR(10);

UPDATE walmart.`walmartsalesdata.csv`
SET day_name = DAYNAME(Date);


-- Month_name

SELECT Date,
MONTHNAME(Date) AS Month_name
FROM walmart.`walmartsalesdata.csv`;

ALTER TABLE walmart.`walmartsalesdata.csv` ADD COLUMN Month_name VARCHAR(10);

UPDATE walmart.`walmartsalesdata.csv`
SET Month_name = MONTHNAME(Date);

-- Exploratory Data Analysis (EDA)--
-- Generic Questions
-- 1.How many distinct cities are present in the dataset?
SELECT DISTINCT city FROM walmart.`walmartsalesdata.csv`;

-- 2.In which city is each branch situated?
SELECT DISTINCT branch, city FROM walmart.`walmartsalesdata.csv`;

-- Product Analysis
-- 1.How many distinct product lines are there in the dataset?
SELECT COUNT(DISTINCT `Product line`) FROM walmart.`walmartsalesdata.csv`;

-- 2.What is the most common payment method?
SELECT payment, COUNT(payment) AS common_payment_method 
FROM walmart.`walmartsalesdata.csv` GROUP BY payment ORDER BY common_payment_method DESC LIMIT 1;

-- 3.What is the most selling product line?
SELECT `product line`, count(`product line`) AS Most_selling_product
FROM walmart.`walmartsalesdata.csv` GROUP BY `product line` ORDER BY most_selling_product DESC LIMIT 1;

-- 4.What is the total revenue by month?
SELECT month_name, SUM(total) AS total_revenue
FROM walmart.`walmartsalesdata.csv` GROUP BY month_name ORDER BY total_revenue DESC;

-- 5.Which month recorded the highest Cost of Goods Sold (COGS)?
SELECT month_name, SUM(cogs) AS total_cogs
FROM walmart.`walmartsalesdata.csv` GROUP BY month_name ORDER BY total_cogs DESC;

-- 6.Which product line generated the highest revenue?
SELECT `Product line`, SUM(total) AS total_revenue
FROM walmart.`walmartsalesdata.csv` GROUP BY `Product line` ORDER BY total_revenue DESC LIMIT 1;

-- 7.Which city has the highest revenue?
SELECT city, SUM(total) AS total_revenue
FROM walmart.`walmartsalesdata.csv` GROUP BY city ORDER BY total_revenue DESC LIMIT 1;

-- 8.Which product line incurred the highest VAT?
SELECT `Product line`, SUM(`Tax 5%`) as VAT 
FROM walmart.`walmartsalesdata.csv` GROUP BY `Product line` ORDER BY VAT DESC LIMIT 1;

-- 9.Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,'based on whether its sales are above the average.

ALTER TABLE walmart.`walmartsalesdata.csv` ADD COLUMN product_category VARCHAR(20);

UPDATE walmart.`walmartsalesdata.csv` 
SET product_category= 
CASE 
	WHEN total >= (SELECT AVG(total) FROM sales) THEN "Good"
    ELSE "Bad"
END;

-- 10.Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS quantity
FROM walmart.`walmartsalesdata.csv` GROUP BY branch HAVING SUM(quantity) > AVG(quantity) ORDER BY quantity DESC LIMIT 1;

-- 11.What is the most common product line by gender?
SELECT gender, `Product line`, COUNT(Gender) total_count
FROM walmart.`walmartsalesdata.csv` GROUP BY Gender, `Product line` ORDER BY total_count DESC;


-- 12.What is the average rating of each product line?
SELECT `Product line`, ROUND(AVG(rating),2) average_rating
FROM walmart.`walmartsalesdata.csv` GROUP BY `Product line` ORDER BY average_rating DESC;


-- Sales Analysis

-- 1.Number of sales made in each time of the day per weekday
SELECT day_name, time_of_day, COUNT(`invoice id`) AS total_sales
FROM walmart.`walmartsalesdata.csv` GROUP BY day_name, time_of_day HAVING day_name NOT IN ('Sunday','Saturday');

SELECT day_name, time_of_day, COUNT(*) AS total_sales
FROM walmart.`walmartsalesdata.csv` WHERE day_name NOT IN ('Saturday','Sunday') GROUP BY day_name, time_of_day;

-- 2.Identify the customer type that generates the highest revenue.
SELECT `customer type`, SUM(total) AS total_sales
FROM walmart.`walmartsalesdata.csv` GROUP BY `customer type` ORDER BY total_sales DESC LIMIT 1;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, SUM(`TAX 5%`) AS total_VAT
FROM walmart.`walmartsalesdata.csv` GROUP BY city ORDER BY total_VAT DESC LIMIT 1;

-- 4.Which customer type pays the most in VAT?
SELECT `customer type`, SUM(`TAX 5%`) AS total_VAT
FROM walmart.`walmartsalesdata.csv` GROUP BY `customer type` ORDER BY total_VAT DESC LIMIT 1;

-- Customer Analysis

-- 1.How many unique customer types does the data have?
SELECT COUNT(DISTINCT `customer type`) FROM walmart.`walmartsalesdata.csv`;

-- 2.How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) FROM walmart.`walmartsalesdata.csv`;

-- 3.Which is the most common customer type?
SELECT `customer type`, COUNT(`customer type`) AS common_customer
FROM walmart.`walmartsalesdata.csv` GROUP BY `customer type` ORDER BY common_customer DESC LIMIT 1;

-- 4.Which customer type buys the most?
SELECT `customer type`, SUM(total) as total_sales
FROM walmart.`walmartsalesdata.csv` GROUP BY `customer type` ORDER BY total_sales LIMIT 1;

SELECT `customer type`, COUNT(*) AS most_buyer
FROM sales GROUP BY customer_type ORDER BY most_buyer DESC LIMIT 1;

-- 5.What is the gender of most of the customers?
SELECT gender, COUNT(*) AS all_genders 
FROM walmart.`walmartsalesdata.csv` GROUP BY gender ORDER BY all_genders DESC LIMIT 1;

-- 6.What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) AS gender_distribution
FROM walmart.`walmartsalesdata.csv` GROUP BY branch, gender ORDER BY branch;

-- 7.Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS average_rating
FROM walmart.`walmartsalesdata.csv` GROUP BY time_of_day ORDER BY average_rating DESC LIMIT 1;

-- 8.Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, AVG(rating) AS average_rating
FROM walmart.`walmartsalesdata.csv` GROUP BY branch, time_of_day ORDER BY average_rating DESC;

-- 9.Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS average_rating
FROM walmart.`walmartsalesdata.csv` GROUP BY day_name ORDER BY average_rating DESC LIMIT 1;

-- 10.Which day of the week has the best average ratings per branch?
select 
      day_name, 
      branch, 
      avg(rating) as 'Average Raring'
from walmart.`walmartsalesdata.csv`
      where branch in ('A', 'B', 'C')
      group by day_name, branch
      order by avg(rating) desc;

