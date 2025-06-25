

-- CREATE TABLE
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,	
    sale_date DATE,	 
    sale_time TIME,	
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),	
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- VIEW SAMPLE RECORDS
SELECT * FROM retail_sales
LIMIT 10;

-- COUNT TOTAL ROWS
SELECT COUNT(*) FROM retail_sales;


-- Check if any rows have NULL transaction_id
SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

-- Check if any rows have NULL sale_date
SELECT * FROM retail_sales
WHERE sale_date IS NULL;

-- Check if any rows have NULL sale_time
SELECT * FROM retail_sales
WHERE sale_time IS NULL;

-- Check all essential fields for NULLs
SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL OR
    sale_date IS NULL OR 
    sale_time IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

-- DELETE records with NULLs in critical fields
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL OR
    sale_date IS NULL OR 
    sale_time IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- What are the distinct product categories available?
SELECT DISTINCT category
FROM retail_sales
ORDER BY category;


-- ===============================
-- 🎯 DATA ANALYSIS QUESTIONS
-- ===============================

-- Q1. Retrieve all sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Transactions where category = 'Clothing' and quantity > 10 in Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 10
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q3. Total sales for each category
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Q4. Average age of customers who purchased 'Beauty'
SELECT AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Transactions where total_sale > 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Number of transactions by gender in each category
SELECT gender, category, COUNT(transaction_id) AS transaction_count
FROM retail_sales
GROUP BY gender, category
ORDER BY transaction_count DESC;

-- Q7. Average sale per month & best-selling month per year
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_monthly_sale
FROM retail_sales
GROUP BY year, month
ORDER BY avg_monthly_sale DESC;


-- Q8. Top 5 customers based on highest total sales
SELECT customer_id, SUM(total_sale) AS customer_total
FROM retail_sales
GROUP BY customer_id
ORDER BY customer_total DESC
LIMIT 5;

-- Q9. Unique customers who purchased each category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- Q10. Orders by shift: Morning, Afternoon, Evening
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS order_count
FROM retail_sales
GROUP BY shift;

-- Q11. Category-wise average quantity sold
SELECT category, ROUND(AVG(quantity), 2) AS avg_quantity
FROM retail_sales
GROUP BY category;

-- Q12. Gender-wise total COGS
SELECT gender, SUM(cogs) AS total_cogs
FROM retail_sales
GROUP BY gender
ORDER BY total_cogs DESC;

-- Q13. Age group buying analysis
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS age_group,
    COUNT(*) AS orders
FROM retail_sales
GROUP BY age_group
ORDER BY orders DESC;

-- Q14. Top 3 most frequently purchased categories
SELECT category, COUNT(*) AS order_count
FROM retail_sales
GROUP BY category
ORDER BY order_count DESC
LIMIT 3;

-- Q15. Revenue % contribution by each category
SELECT 
    category,
    ROUND((SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail_sales))::numeric, 2) AS revenue_percent
FROM retail_sales
GROUP BY category
ORDER BY revenue_percent DESC;


-- Q16. Daily average sales trend
SELECT 
    sale_date, 
    ROUND(AVG(total_sale)::numeric, 2) AS avg_daily_sale
FROM retail_sales
GROUP BY sale_date
ORDER BY sale_date;


-- Q17. Gender-wise average order value
SELECT 
    gender, 
    ROUND(AVG(total_sale)::numeric, 2) AS avg_order_value
FROM retail_sales
GROUP BY gender;


-- Q18. High-value customers (spent > ₹5000)
SELECT 
    customer_id, 
    SUM(total_sale)::numeric AS total_spent
FROM retail_sales
GROUP BY customer_id
HAVING SUM(total_sale) > 5000
ORDER BY total_spent DESC;

-- Q19. Average price per unit per category
SELECT 
    category, 
    ROUND(AVG(price_per_unit)::numeric, 2) AS avg_price
FROM retail_sales
GROUP BY category;

-- Q20. Customers who purchased from 3 or more categories
SELECT customer_id, COUNT(DISTINCT category) AS category_count
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) >= 3;


