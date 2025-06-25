CREATE SCHEMA IF NOT EXISTS alien_db;

-- Drop and Create `aliens` table
DROP TABLE IF EXISTS alien_db.aliens;
CREATE TABLE alien_db.aliens (
	id INT PRIMARY KEY, 
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	email VARCHAR(250),
	gender VARCHAR(50),
	type VARCHAR(50), 
	birth_year INT
);

-- Drop and Create `details` table
DROP TABLE IF EXISTS alien_db.details;
CREATE TABLE alien_db.details (
	detail_id INT PRIMARY KEY, 
	favorite_food VARCHAR(250),
	feeding_frequency VARCHAR(50), 
	aggressive BOOLEAN
);

-- Drop and Create `location` table
DROP TABLE IF EXISTS alien_db.location;
CREATE TABLE alien_db.location (
	loc_id INT PRIMARY KEY, 
	current_location VARCHAR(100),
	state VARCHAR(50),
	country VARCHAR(150),
	occupation VARCHAR(250)
);


-- 1. Total records in aliens table
SELECT COUNT(*) AS total_aliens FROM alien_db.aliens;

-- 2. Check for duplicate emails
SELECT email, COUNT(*) AS count 
FROM alien_db.aliens 
GROUP BY email 
HAVING COUNT(*) > 1;

-- 3. Count of unique countries
SELECT COUNT(DISTINCT country) AS unique_countries 
FROM alien_db.location;

-- 4. Count of unique states
SELECT COUNT(DISTINCT state) AS unique_states 
FROM alien_db.location;

-- 5. Max age
SELECT MAX(EXTRACT(YEAR FROM CURRENT_DATE) - birth_year) AS max_age 
FROM alien_db.aliens;

-- 6. Min age
SELECT MIN(EXTRACT(YEAR FROM CURRENT_DATE) - birth_year) AS min_age 
FROM alien_db.aliens;

-- 7. Gender distribution
SELECT LOWER(gender) AS gender, COUNT(*) AS count 
FROM alien_db.aliens 
GROUP BY LOWER(gender);

-- 8. List of all alien types
SELECT DISTINCT type FROM alien_db.aliens;

-- 9. Common feeding frequencies
SELECT feeding_frequency, COUNT(*) 
FROM alien_db.details 
GROUP BY feeding_frequency;

-- 10. Top 5 favorite foods
SELECT favorite_food, COUNT(*) 
FROM alien_db.details 
GROUP BY favorite_food 
ORDER BY COUNT(*) DESC 
LIMIT 5;

-- 11. Alien count per state + avg age + aggression %
SELECT 
  l.state,
  COUNT(*) AS alien_count,
  AVG(EXTRACT(YEAR FROM CURRENT_DATE) - a.birth_year) AS avg_age,
  ROUND(SUM(CASE WHEN d.aggressive THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS aggression_pct
FROM alien_db.aliens a
JOIN alien_db.details d ON a.id = d.detail_id
JOIN alien_db.location l ON a.id = l.loc_id
GROUP BY l.state;

-- 12. Population per country + %
SELECT 
  country,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM alien_db.location
GROUP BY country;

-- 13. Gender breakdown per country
SELECT 
  l.country,
  LOWER(a.gender) AS gender,
  COUNT(*) AS count
FROM alien_db.aliens a
JOIN alien_db.location l ON a.id = l.loc_id
GROUP BY l.country, LOWER(a.gender)
ORDER BY l.country;

-- 14. Top 2 species per country
SELECT * FROM (
  SELECT 
    l.country,
    a.type,
    COUNT(*) AS species_count,
    ROW_NUMBER() OVER (PARTITION BY l.country ORDER BY COUNT(*) DESC) AS rn
  FROM alien_db.aliens a
  JOIN alien_db.location l ON a.id = l.loc_id
  GROUP BY l.country, a.type
) ranked
WHERE rn <= 2;

-- 15. Favorite food per species
SELECT 
  a.type,
  d.favorite_food,
  COUNT(*) AS count
FROM alien_db.aliens a
JOIN alien_db.details d ON a.id = d.detail_id
GROUP BY a.type, d.favorite_food
ORDER BY a.type, count DESC;

-- 16. Feeding frequency by type
SELECT 
  a.type,
  d.feeding_frequency,
  COUNT(*) 
FROM alien_db.aliens a
JOIN alien_db.details d ON a.id = d.detail_id
GROUP BY a.type, d.feeding_frequency;

-- 17. Friendly vs. hostile aliens
SELECT 
  d.aggressive,
  COUNT(*) AS count
FROM alien_db.details d
GROUP BY d.aggressive;

-- 18. Top 10 cities – hostile vs. friendly
SELECT 
  l.current_location,
  d.aggressive,
  COUNT(*) AS count
FROM alien_db.location l
JOIN alien_db.details d ON l.loc_id = d.detail_id
GROUP BY l.current_location, d.aggressive
ORDER BY count DESC
LIMIT 10;

-- 19. Top 5 occupations for aggressive aliens
SELECT 
  l.occupation,
  COUNT(*) AS aggressive_count
FROM alien_db.location l
JOIN alien_db.details d ON l.loc_id = d.detail_id
WHERE d.aggressive = TRUE
GROUP BY l.occupation
ORDER BY aggressive_count DESC
LIMIT 5;

-- 20. Top 5 occupations for friendly aliens
SELECT 
  l.occupation,
  COUNT(*) AS friendly_count
FROM alien_db.location l
JOIN alien_db.details d ON l.loc_id = d.detail_id
WHERE d.aggressive = FALSE
GROUP BY l.occupation
ORDER BY friendly_count DESC
LIMIT 5;

-- 21. Average age by gender and state
SELECT 
  LOWER(a.gender) AS gender,
  l.state,
  AVG(EXTRACT(YEAR FROM CURRENT_DATE) - a.birth_year) AS avg_age
FROM alien_db.aliens a
JOIN alien_db.location l ON a.id = l.loc_id
GROUP BY LOWER(a.gender), l.state;

-- 22. States with more than 10 aggressive aliens
SELECT 
  l.state,
  COUNT(*) AS aggressive_aliens
FROM alien_db.location l
JOIN alien_db.details d ON l.loc_id = d.detail_id
WHERE d.aggressive = TRUE
GROUP BY l.state
HAVING COUNT(*) > 10;

-- 23. Type distribution per state
SELECT 
  l.state,
  a.type,
  COUNT(*) AS count
FROM alien_db.aliens a
JOIN alien_db.location l ON a.id = l.loc_id
GROUP BY l.state, a.type;

-- 24. State with youngest average age
SELECT 
  l.state,
  AVG(EXTRACT(YEAR FROM CURRENT_DATE) - a.birth_year) AS avg_age
FROM alien_db.aliens a
JOIN alien_db.location l ON a.id = l.loc_id
GROUP BY l.state
ORDER BY avg_age ASC
LIMIT 1;

-- 25. Feeding frequency breakdown by aggression
SELECT 
  d.feeding_frequency,
  d.aggressive,
  COUNT(*) 
FROM alien_db.details d
GROUP BY d.feeding_frequency, d.aggressive;

-- 26. Top food by region (assuming mapping later)
-- Placeholder: once `region` is added
-- SELECT region, favorite_food, COUNT(*) ...

-- 27. Cities with highest alien diversity
SELECT 
  l.current_location,
  COUNT(DISTINCT a.type) AS species_diversity
FROM alien_db.aliens a
JOIN alien_db.location l ON a.id = l.loc_id
GROUP BY l.current_location
ORDER BY species_diversity DESC
LIMIT 10;

-- 28. Age group distribution
SELECT 
  CASE 
    WHEN age < 100 THEN 'Young'
    WHEN age BETWEEN 100 AND 200 THEN 'Middle'
    ELSE 'Old'
  END AS age_group,
  COUNT(*)
FROM (
  SELECT (EXTRACT(YEAR FROM CURRENT_DATE) - birth_year) AS age 
  FROM alien_db.aliens
) AS sub
GROUP BY age_group;

-- 29. Species count by gender
SELECT 
  a.gender,
  a.type,
  COUNT(*) 
FROM alien_db.aliens a
GROUP BY a.gender, a.type;

-- 30. Aggression % by type
SELECT 
  a.type,
  ROUND(SUM(CASE WHEN d.aggressive THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS aggression_pct
FROM alien_db.aliens a
JOIN alien_db.details d ON a.id = d.detail_id
GROUP BY a.type;


