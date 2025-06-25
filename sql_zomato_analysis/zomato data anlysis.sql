CREATE TABLE customers (
    customer_id     VARCHAR(10) PRIMARY KEY,
    customer_name   VARCHAR(50),
    reg_date        DATE
);

CREATE TABLE restaurants (
    restaurant_id       VARCHAR(10) PRIMARY KEY,
    restaurant_name     VARCHAR(50),
    city                VARCHAR(20),
    opening_hours       VARCHAR(50)
);

CREATE TABLE riders (
    rider_id    VARCHAR(10) PRIMARY KEY,
    rider_name  VARCHAR(30),
    sign_up     DATE
);

CREATE TABLE orders (
    order_id        VARCHAR(10) PRIMARY KEY,
    customer_id     VARCHAR(10),
    restaurant_id   VARCHAR(10),
    order_item      VARCHAR(60),
    order_date      DATE,	
    order_time      TIME,
    order_status    VARCHAR(55),
    total_amount    FLOAT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE deliveries (
    delivery_id     VARCHAR(10) PRIMARY KEY,
    order_id        VARCHAR(10),
    delivery_status VARCHAR(40),
    delivery_time   TIME,
    rider_id        VARCHAR(10),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);

---------------------*Data Cleaning*---------------------------
-- Example: Find NULLs
SELECT * FROM orders WHERE order_id IS NULL OR total_amount IS NULL;

-- Delete rows with NULLs (if any)
DELETE FROM orders WHERE order_id IS NULL OR total_amount IS NULL;


---------------------*EDA*----------------------------


-- Total number of orders
SELECT COUNT(*) FROM orders;

-- Unique cities
SELECT DISTINCT city FROM restaurants;

-- Top 5 most ordered items
SELECT order_item, COUNT(*) AS order_count
FROM orders
GROUP BY order_item
ORDER BY order_count DESC
LIMIT 5;

---------------------------------------------------------------------


-- ✅ Task 1: Top 5 most frequently ordered dishes by "Arjun Mehta" in the last 1 year
SELECT *
FROM (
    SELECT 
        c.customer_name,
        o.order_item,
        COUNT(o.order_item) AS number_of_item,
        DENSE_RANK() OVER (ORDER BY COUNT(o.order_item) DESC) AS Ranks
    FROM customers c
    JOIN orders o USING (customer_id)
    WHERE order_date BETWEEN '2023-09-28' AND '2024-09-29'
    AND c.customer_name = 'Arjun Mehta'
    GROUP BY c.customer_name, o.order_item
) t
WHERE Ranks <= 5;

-- ✅ Task 2: Time slots during which the most orders are placed (2-hour interval)
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '00:00-02:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 2 AND 3 THEN '02:00-04:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 4 AND 5 THEN '04:00-06:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 7 THEN '06:00-08:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 8 AND 9 THEN '08:00-10:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 10 AND 11 THEN '10:00-12:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 13 THEN '12:00-14:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 14 AND 15 THEN '14:00-16:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 16 AND 17 THEN '16:00-18:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 18 AND 19 THEN '18:00-20:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 20 AND 21 THEN '20:00-22:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 22 AND 23 THEN '22:00-00:00'
    END AS time_slot,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY time_slot
ORDER BY order_count DESC;

-- ✅ Task 3: AOV per customer with more than 750 orders
SELECT 
    c.customer_name,
    COUNT(*) AS number_of_orders,
    ROUND(AVG(o.total_amount)) AS AOV
FROM customers c
JOIN orders o USING (customer_id)
GROUP BY c.customer_name
HAVING COUNT(*) > 750
ORDER BY AOV DESC;

-- ✅ Task 4: Customers who spent more than 100K
SELECT * 
FROM (
    SELECT 
        c.customer_name,
        c.customer_id,
        SUM(total_amount) AS Total_spending 
    FROM customers c 
    JOIN orders o USING (customer_id)
    GROUP BY c.customer_name, c.customer_id
) t
WHERE Total_spending > 100000
ORDER BY Total_spending DESC;

-- ✅ Task 5: Orders placed but not delivered
SELECT 
    r.restaurant_name,
    r.city,
    COUNT(*) AS cnt
FROM orders o
LEFT JOIN restaurants r USING (restaurant_id)
LEFT JOIN deliveries d USING (order_id)
WHERE d.delivery_id IS NULL
GROUP BY r.restaurant_name, r.city
ORDER BY cnt DESC;

-- ✅ Task 6: Rank restaurants by revenue within city for 2023
SELECT 
    r.restaurant_name,
    r.city,
    SUM(total_amount) AS total_revenue,
    DENSE_RANK() OVER (PARTITION BY r.city ORDER BY SUM(total_amount) DESC) AS rank_in_city
FROM orders o
LEFT JOIN restaurants r USING (restaurant_id)
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY r.restaurant_name, r.city;

-- ✅ Task 7: Most popular dish in each city
SELECT *
FROM (
    SELECT 
        r.city,
        o.order_item,
        COUNT(*) AS number_of_orders,
        DENSE_RANK() OVER (PARTITION BY r.city ORDER BY COUNT(*) DESC) AS ranks
    FROM orders o
    JOIN restaurants r USING (restaurant_id)
    GROUP BY r.city, o.order_item
) t
WHERE ranks = 1;

-- ✅ Task 8: Customers active in 2023 but not in 2024
WITH cust_cte AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        EXTRACT(YEAR FROM o.order_date) AS year
    FROM customers c
    JOIN orders o USING (customer_id)
)
SELECT DISTINCT customer_id, customer_name 
FROM cust_cte
WHERE year = 2023
AND customer_id NOT IN (
    SELECT customer_id FROM cust_cte WHERE year = 2024
);

-- ✅ Task 9: Compare restaurant order cancellation between 2023 and 2024
WITH cte_2023 AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        COUNT(*) AS cancel_2023 
    FROM orders o
    LEFT JOIN restaurants r USING (restaurant_id)
    LEFT JOIN deliveries d USING (order_id)
    WHERE d.delivery_status IS NULL AND EXTRACT(YEAR FROM order_date) = 2023
    GROUP BY 1, 2
),
cte_2024 AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        COUNT(*) AS cancel_2024 
    FROM orders o
    LEFT JOIN restaurants r USING (restaurant_id)
    LEFT JOIN deliveries d USING (order_id)
    WHERE d.delivery_status IS NULL AND EXTRACT(YEAR FROM order_date) = 2024
    GROUP BY 1, 2
)
SELECT 
    cte_2023.restaurant_id,
    cte_2023.restaurant_name,
    cte_2023.cancel_2023,
    cte_2024.cancel_2024
FROM cte_2023
LEFT JOIN cte_2024 USING (restaurant_id);

-- ✅ Task 10: Restaurant growth ratio in delivered orders month-wise
WITH cte AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        EXTRACT(MONTH FROM order_date) AS months,
        EXTRACT(YEAR FROM order_date) AS years,
        COUNT(*) AS number_of_delivered_orders
    FROM orders o 
    LEFT JOIN restaurants r USING (restaurant_id)
    LEFT JOIN deliveries d USING (order_id)
    WHERE d.delivery_status = 'Delivered'
    GROUP BY 1, 2, 3, 4
)
SELECT *, 
    ROUND(((number_of_delivered_orders - pre_orders) * 100.0 / NULLIF(pre_orders, 0)), 2) AS growth
FROM (
    SELECT *, 
        LAG(number_of_delivered_orders) OVER (PARTITION BY restaurant_id ORDER BY years, months) AS pre_orders
    FROM cte
) t;

-- ✅ Task 11: Rider's monthly earnings (8% commission)
SELECT 
    r.rider_id,
    r.rider_name,
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(MONTH FROM o.order_date) AS month,
    SUM(o.total_amount) AS total_revenue, 
    ROUND(SUM(o.total_amount)::numeric * 0.08, 2) AS monthly_earnings
FROM riders r
LEFT JOIN deliveries d USING (rider_id)
JOIN orders o USING (order_id)
GROUP BY 1, 2, 3, 4
ORDER BY 1, 2, 3, 4;


-- ✅ Task 12: Peak day of the week for each restaurant
SELECT * 
FROM (
    SELECT 
        r.restaurant_name,
        TO_CHAR(o.order_date, 'Day') AS day_name, 
        COUNT(*) AS cnt,
        DENSE_RANK() OVER (PARTITION BY r.restaurant_name ORDER BY COUNT(*) DESC) AS ranks 
    FROM orders o 
    JOIN restaurants r USING (restaurant_id)
    GROUP BY r.restaurant_name, TO_CHAR(o.order_date, 'Day')
) t
WHERE ranks = 1;

-- ✅ Task 13: Total revenue generated by each customer
SELECT 
    c.customer_id,
    c.customer_name, 
    SUM(total_amount) AS total_revenue
FROM customers c 
JOIN orders o USING (customer_id) 
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC;

-- ✅ Task 14: Monthly sales trend with growth %
WITH cte AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month,
        TO_CHAR(order_date, 'Month') AS name_month,
        SUM(total_amount) AS total_revenue 
    FROM orders 
    GROUP BY 1, 2, 3
)
SELECT *,
    LAG(total_revenue) OVER (ORDER BY year, month) AS pre_revenue,
    ROUND(
        ((total_revenue - LAG(total_revenue) OVER (ORDER BY year, month))::numeric * 100.0) / 
        NULLIF(LAG(total_revenue) OVER (ORDER BY year, month)::numeric, 0), 2
    ) AS growth
FROM cte;

-- ✅ Task 15: Seasonal demand spike analysis
SELECT 
    order_item, 
    COUNT(CASE WHEN EXTRACT(MONTH FROM order_date) IN (12, 1, 2) THEN 1 END) AS "Winter",
    COUNT(CASE WHEN EXTRACT(MONTH FROM order_date) IN (3, 4, 5) THEN 1 END) AS "Spring",
    COUNT(CASE WHEN EXTRACT(MONTH FROM order_date) IN (6, 7, 8) THEN 1 END) AS "Summer",
    COUNT(CASE WHEN EXTRACT(MONTH FROM order_date) IN (9, 10, 11) THEN 1 END) AS "Autumn"
FROM orders 
GROUP BY order_item
ORDER BY "Winter" DESC, "Spring" DESC;

-- ✅ Task 16: Rank each city by total revenue for 2023
SELECT 
    r.city, 
    SUM(o.total_amount) AS total_revenue,
    DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS city_rank
FROM restaurants r 
JOIN orders o USING (restaurant_id)
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY r.city;




