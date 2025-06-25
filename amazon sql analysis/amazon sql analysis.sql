DROP TABLE IF EXISTS amazon_products;

CREATE TABLE amazon_products (
    product_id VARCHAR PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    discounted_price NUMERIC(10, 2),
    actual_price NUMERIC(10, 2),
    discount_percentage NUMERIC(5, 2),
    rating NUMERIC(3, 2),
    rating_count NUMERIC(10, 2),
    about_product TEXT,
    user_id TEXT,
    user_name TEXT,
    review_id TEXT,
    review_title TEXT,
    review_content TEXT,
    img_link TEXT,
    product_link TEXT
);
-------------------data cleaning---------------------------
-- Find NULLs across key fields
SELECT COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
       COUNT(*) FILTER (WHERE product_name IS NULL) AS null_product_name,
       COUNT(*) FILTER (WHERE discounted_price IS NULL) AS null_discounted_price,
       COUNT(*) FILTER (WHERE rating IS NULL) AS null_rating
FROM amazon_products;

-- Remove rows with NULL essential fields (if needed)
DELETE FROM amazon_products
WHERE product_id IS NULL OR product_name IS NULL OR discounted_price IS NULL;

-----------------------Business Analysis Queries (Q1–Q20)-----------------

-- Q1: Total number of products
SELECT COUNT(*) AS total_products FROM amazon_products;

-- Q2: Number of unique categories
SELECT COUNT(DISTINCT category) AS unique_categories FROM amazon_products;

-- Q3: Average discount percentage by category
SELECT category, ROUND(AVG(discount_percentage), 2) AS avg_discount
FROM amazon_products
GROUP BY category
ORDER BY avg_discount DESC;

-- Q4: Top 10 most reviewed products
SELECT product_name, rating_count
FROM amazon_products
ORDER BY rating_count DESC
LIMIT 10;

-- Q5: Average rating by category
SELECT category, ROUND(AVG(rating), 2) AS avg_rating
FROM amazon_products
GROUP BY category
ORDER BY avg_rating DESC;

-- Q6: Products with highest discounts
SELECT product_name, discount_percentage
FROM amazon_products
ORDER BY discount_percentage DESC
LIMIT 10;

-- Q7: Top 5 categories with highest number of products
SELECT category, COUNT(*) AS total
FROM amazon_products
GROUP BY category
ORDER BY total DESC
LIMIT 5;

-- Q8: Average actual price per category
SELECT category, ROUND(AVG(actual_price), 2) AS avg_actual_price
FROM amazon_products
GROUP BY category;

-- Q9: Average discounted price per category
SELECT category, ROUND(AVG(discounted_price), 2) AS avg_discounted_price
FROM amazon_products
GROUP BY category;

-- Q10: Product with maximum rating
SELECT product_name, rating
FROM amazon_products
WHERE rating IS NOT NULL
ORDER BY rating DESC
LIMIT 1;

-- Q11: Number of products with 5-star ratings
SELECT COUNT(*) AS five_star_count
FROM amazon_products
WHERE rating = 5;

-- Q12: Count of products with rating < 3
SELECT COUNT(*) AS low_rating_count
FROM amazon_products
WHERE rating < 3;

-- Q13: Top 5 users with most reviews
SELECT user_name, COUNT(*) AS total_reviews
FROM amazon_products
WHERE user_name IS NOT NULL
GROUP BY user_name
ORDER BY total_reviews DESC
LIMIT 5;

-- Q14: Most common words in review titles (if supported by text search)
-- (For full text search setup in PostgreSQL)
-- Not natively supported without indexing — skip if not using tsvector

-- Q15: Price difference analysis (actual vs. discounted)
SELECT product_name, actual_price - discounted_price AS savings
FROM amazon_products
ORDER BY savings DESC
LIMIT 10;

-- Q16: Rating distribution
SELECT rating, COUNT(*) AS count
FROM amazon_products
GROUP BY rating
ORDER BY rating DESC;

-- Q17: Average discount by rating level
SELECT ROUND(rating, 1) AS rating_group, ROUND(AVG(discount_percentage), 2) AS avg_discount
FROM amazon_products
GROUP BY rating_group
ORDER BY rating_group DESC;

-- Q18: Top rated products (rating > 4.5 and rating_count > 1000)
SELECT product_name, rating, rating_count
FROM amazon_products
WHERE rating > 4.5 AND rating_count > 1000
ORDER BY rating DESC;

-- Q19: Products reviewed by user 'Amazon Customer'
SELECT *
FROM amazon_products
WHERE user_name = 'Amazon Customer';

-- Q20: Products with no reviews
SELECT COUNT(*) AS no_reviews
FROM amazon_products
WHERE rating_count = 0 OR rating_count IS NULL;

-- Q21: Which category has the best average rating AND highest average discount?
SELECT category, ROUND(AVG(rating), 2) AS avg_rating, ROUND(AVG(discount_percentage), 2) AS avg_discount
FROM amazon_products
GROUP BY category
ORDER BY avg_rating DESC, avg_discount DESC
LIMIT 5;

-- Q22: Top 10 most helpful reviews (based on review length)
SELECT product_name, review_title, LENGTH(review_content) AS review_length
FROM amazon_products
WHERE review_content IS NOT NULL
ORDER BY review_length DESC
LIMIT 10;

-- Q23: Products with misleading discounts (discount > 90% but rating < 2)
SELECT product_name, discount_percentage, rating
FROM amazon_products
WHERE discount_percentage > 90 AND rating < 2;

-- Q24: Correlation analysis: average rating vs. average price by category
SELECT category, ROUND(AVG(rating), 2) AS avg_rating, ROUND(AVG(actual_price), 2) AS avg_price
FROM amazon_products
GROUP BY category
ORDER BY avg_rating DESC;

-- Q25: Top 5 trending products (high rating + high review count + high discount)
SELECT product_name, rating, rating_count, discount_percentage
FROM amazon_products
WHERE rating >= 4.5 AND rating_count >= 1000 AND discount_percentage >= 50
ORDER BY rating DESC, rating_count DESC
LIMIT 5;







