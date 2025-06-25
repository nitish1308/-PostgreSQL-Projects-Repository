
CREATE SCHEMA IF NOT EXISTS chicago_crashes;

CREATE TABLE chicago_crashes.part_1 (
    crash_id TEXT,
    crash_date TEXT,
    posted_speed_limit INTEGER,
    traffic_control_device TEXT,
    device_condition TEXT,
    weather_condition TEXT,
    lighting_condition TEXT,
    first_crash_type TEXT,
    trafficway_type TEXT,
    lane_count INTEGER,
    alignment TEXT,
    roadway_surface_condition TEXT,
    road_defect TEXT,
    report_type TEXT,
    crash_type TEXT,
    "hit_and run" TEXT,
    damage TEXT,
    date_police_notified TEXT,
    primary_cause TEXT,
    secondary_cause TEXT,
    street_direction TEXT,
    street_name TEXT,
    statement_taken TEXT,
    work_zone TEXT,
    work_zone_type TEXT,
    workers_present TEXT,
    number_units INTEGER,
    most_severe_injury TEXT,
    injuries_total INTEGER,
    injuries_fatal INTEGER,
    injuries_incapacitation INTEGER,
    injuries_non_incapacitation INTEGER,
    injuries_reported_not_evident INTEGER,
    crash_hour INTEGER,
    crash_day_of_week TEXT,
    crash_month INTEGER,
    latitude NUMERIC,
    longitude NUMERIC,
    crash_location TEXT
);

CREATE TABLE chicago_crashes.part_2 (
    crash_id TEXT,
    crash_date TEXT,
    posted_speed_limit INTEGER,
    traffic_control_device TEXT,
    device_condition TEXT,
    weather_condition TEXT,
    lighting_condition TEXT,
    first_crash_type TEXT,
    trafficway_type TEXT,
    lane_count INTEGER,
    alignment TEXT,
    roadway_surface_condition TEXT,
    road_defect TEXT,
    report_type TEXT,
    crash_type TEXT,
    "hit_and run" TEXT,
    damage TEXT,
    date_police_notified TEXT,
    primary_cause TEXT,
    secondary_cause TEXT,
    street_direction TEXT,
    street_name TEXT,
    statement_taken TEXT,
    work_zone TEXT,
    work_zone_type TEXT,
    workers_present TEXT,
    number_units INTEGER,
    most_severe_injury TEXT,
    injuries_total INTEGER,
    injuries_fatal INTEGER,
    injuries_incapacitation INTEGER,
    injuries_non_incapacitation INTEGER,
    injuries_reported_not_evident INTEGER,
    crash_hour INTEGER,
    crash_day_of_week TEXT,
    crash_month INTEGER,
    latitude NUMERIC,
    longitude NUMERIC,
    crash_location TEXT
);

CREATE TABLE chicago_crashes.part_3 (
    crash_id TEXT,
    crash_date TEXT,
    posted_speed_limit INTEGER,
    traffic_control_device TEXT,
    device_condition TEXT,
    weather_condition TEXT,
    lighting_condition TEXT,
    first_crash_type TEXT,
    trafficway_type TEXT,
    lane_count INTEGER,
    alignment TEXT,
    roadway_surface_condition TEXT,
    road_defect TEXT,
    report_type TEXT,
    crash_type TEXT,
    "hit_and run" TEXT,
    damage TEXT,
    date_police_notified TEXT,
    primary_cause TEXT,
    secondary_cause TEXT,
    street_direction TEXT,
    street_name TEXT,
    statement_taken TEXT,
    work_zone TEXT,
    work_zone_type TEXT,
    workers_present TEXT,
    number_units INTEGER,
    most_severe_injury TEXT,
    injuries_total INTEGER,
    injuries_fatal INTEGER,
    injuries_incapacitation INTEGER,
    injuries_non_incapacitation INTEGER,
    injuries_reported_not_evident INTEGER,
    crash_hour INTEGER,
    crash_day_of_week TEXT,
    crash_month INTEGER,
    latitude NUMERIC,
    longitude NUMERIC,
    crash_location TEXT
);

CREATE TABLE chicago_crashes.crashes_merged AS
SELECT * FROM chicago_crashes.part_1
UNION ALL
SELECT * FROM chicago_crashes.part_2
UNION ALL
SELECT * FROM chicago_crashes.part_3;

SELECT COUNT(*) FROM chicago_crashes.crashes_merged;



-- 🔹 EASY LEVEL QUESTIONS (1–10)

-- 1. How many total crashes are recorded?
SELECT COUNT(*) FROM chicago_crashes.crashes_merged;

-- 2. How many crashes occurred during the day (lighting_condition = 'DAYLIGHT')?
SELECT COUNT(*) FROM chicago_crashes.crashes_merged
WHERE lighting_condition = 'DAYLIGHT';

-- 3. How many unique weather conditions were reported?
SELECT COUNT(DISTINCT weather_condition) FROM chicago_crashes.crashes_merged;

-- 4. What are the top 5 most frequent crash types?
SELECT crash_type, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY crash_type
ORDER BY total DESC
LIMIT 5;

-- 5. What is the average number of units involved in crashes?
SELECT AVG(number_units) FROM chicago_crashes.crashes_merged;

-- 6. How many crashes involved injuries?
SELECT COUNT(*) FROM chicago_crashes.crashes_merged
WHERE injuries_total > 0;

-- 7. What is the most common primary cause of crashes?
SELECT primary_cause, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY primary_cause
ORDER BY total DESC
LIMIT 1;

-- 8. How many crashes happened with posted speed limit above 40?
SELECT COUNT(*) FROM chicago_crashes.crashes_merged
WHERE posted_speed_limit > 40;

-- 9. What are the most common 3 weather conditions during crashes?
SELECT weather_condition, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY weather_condition
ORDER BY total DESC
LIMIT 3;

-- 10. How many crashes occurred on roads with 2 lanes?
SELECT COUNT(*) FROM chicago_crashes.crashes_merged
WHERE lane_count = 2;

-- 🔸 INTERMEDIATE LEVEL QUESTIONS (11–20)

-- 11. Which day of the week had the highest number of crashes?
SELECT crash_day_of_week, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY crash_day_of_week
ORDER BY total DESC
LIMIT 1;

-- 12. What’s the average number of injuries per crash?
SELECT AVG(injuries_total) FROM chicago_crashes.crashes_merged;

-- 13. How many crashes were hit-and-run cases?
SELECT COUNT(*) FROM chicago_crashes.crashes_merged
WHERE "hit_and run" = 'YES';

-- 14. How many crashes occurred in each crash month?
SELECT crash_month, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY crash_month
ORDER BY crash_month;

-- 15. What are the top 5 most common first crash types?
SELECT first_crash_type, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY first_crash_type
ORDER BY total DESC
LIMIT 5;

-- 16. Which surface condition had the highest crash rate?
SELECT roadway_surface_condition, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY roadway_surface_condition
ORDER BY total DESC
LIMIT 1;

-- 17. Count the number of fatal crashes.
SELECT COUNT(*) FROM chicago_crashes.crashes_merged
WHERE injuries_fatal > 0;

-- 18. What’s the most common lighting condition for crashes?
SELECT lighting_condition, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY lighting_condition
ORDER BY total DESC
LIMIT 1;

-- 19. What’s the distribution of crash types for crashes with injuries?
SELECT crash_type, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
WHERE injuries_total > 0
GROUP BY crash_type
ORDER BY total DESC;

-- 20. What are the top 3 posted speed limits with most crashes?
SELECT posted_speed_limit, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY posted_speed_limit
ORDER BY total DESC
LIMIT 3;

-- 🔺 ADVANCED LEVEL QUESTIONS (21–30)

-- 21. Find the hour with the most crashes.
SELECT crash_hour, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY crash_hour
ORDER BY total DESC
LIMIT 1;

-- 22. What is the average fatal injuries per crash with fatalities?
SELECT AVG(injuries_fatal) FROM chicago_crashes.crashes_merged
WHERE injuries_fatal > 0;

-- 23. Which street had the most crashes?
SELECT street_name, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY street_name
ORDER BY total DESC
LIMIT 1;

-- 24. Calculate the % of crashes that were hit-and-run.
SELECT 
  ROUND(100.0 * COUNT(*) FILTER (WHERE "hit_and run" = 'YES') / COUNT(*), 2) AS hit_and_run_percentage
FROM chicago_crashes.crashes_merged;

-- 25. Show crash counts by lighting and weather condition.
SELECT lighting_condition, weather_condition, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY lighting_condition, weather_condition
ORDER BY total DESC;

-- 26. Which crash type has the highest average injuries?
SELECT crash_type, AVG(injuries_total) AS avg_injuries
FROM chicago_crashes.crashes_merged
GROUP BY crash_type
ORDER BY avg_injuries DESC
LIMIT 1;

-- 27. Find all crashes that happened in work zones with workers present.
SELECT * FROM chicago_crashes.crashes_merged
WHERE work_zone = 'YES' AND workers_present = 'YES';

-- 28. Show average injuries grouped by number of lanes.
SELECT lane_count, AVG(injuries_total) AS avg_injuries
FROM chicago_crashes.crashes_merged
GROUP BY lane_count
ORDER BY lane_count;

-- 29. Show monthly crash trends (crash_month vs crash count).
SELECT crash_month, COUNT(*) AS total
FROM chicago_crashes.crashes_merged
GROUP BY crash_month
ORDER BY crash_month;

-- 30. Which 5 primary causes are responsible for the most fatal crashes?
SELECT primary_cause, COUNT(*) AS fatal_crash_count
FROM chicago_crashes.crashes_merged
WHERE injuries_fatal > 0
GROUP BY primary_cause
ORDER BY fatal_crash_count DESC
LIMIT 5;

