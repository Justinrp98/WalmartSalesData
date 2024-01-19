CREATE DATABASE IF NOT EXISTS SalesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);

-- ------------------------------------- ADDING COLUMNS TO OUR TABLE ----------------------------------------- 

-- Add new column for time_of_day --
SELECT time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
	CASE
			WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
			WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
			ELSE "Evening"
	END
);


-- Add column day_of_week --
SELECT date, DAYNAME(date) as day_of_week
FROM sales;

ALTER TABLE sales ADD COLUMN day_of_week VARCHAR(10);
UPDATE sales
SET day_of_week = DAYNAME(date);


-- Add column month_name --
SELECT date, MONTHNAME(date) as month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------- EXPLORATORY DATA ANALYSIS ------------------------------------------------------
-- How many unique cities does the data have? List of cities --
SELECT DISTINCT city
FROM sales; 

-- Which branch is in which city? --
SELECT DISTINCT city, branch
FROM sales
ORDER BY branch;

-- How many unique product lines does the data have? --
SELECT COUNT(DISTINCT product_line) as num_lines
FROM sales;

-- What is the most common payment method? --
SELECT payment_method, COUNT(payment_method) as num_pay_method
FROM sales
GROUP BY payment_method
ORDER BY num_pay_method DESC

-- What is the most selling product line? --
SELECT product_line, COUNT(product_line) as product_sold
FROM sales
GROUP BY product_line
ORDER BY product_sold DESC

-- What is the total revenue by month? CHECK THIS ONE --
SELECT month_name, sum(total) as monthly_revenue
FROM sales
GROUP BY month_name
ORDER BY month_name

-- What month had the largest COGS? --
SELECT month_name, sum(cogs) as month_cogs
FROM sales
GROUP BY month_name
ORDER BY month_cogs DESC

-- What product line had the largest revenue --
SELECT product_line, sum(total) as product_total
FROM sales
GROUP BY product_line
ORDER BY product_total DESC

-- What is the city with the largest revenue? --
SELECT city, sum(total) as city_total
FROM sales
GROUP BY city
ORDER BY city_total DESC

-- What product line had the largest VAT? CHECK THIS ONE --
SELECT product_line, sum(vat) as product_vat
FROM sales
GROUP BY product_line
ORDER BY product_vat DESC

-- Fetch each product line and add a column to those showing "Good" if its sales are greater than average and "Bad" if its sales are below average (sales based on quantity sold, not dollar amount) -- 
SELECT AVG(quantity) AS avg_quantity
FROM sales; -- Returns 5.4995 as the average quantity sold across all products --

SELECT product_line,
	CASE
		WHEN AVG(quantity) > 5.4995 THEN "Good" 
        WHEN AVG(quantity) < 5.4995 THEN "Bad"
        ELSE "Average"
	END AS good_bad
FROM sales
GROUP BY product_line;

-- What is the most common product line by gender? --
SELECT gender, product_line, COUNT(gender) as total_count
FROM sales
GROUP BY gender, product_line
ORDER BY gender, total_count DESC