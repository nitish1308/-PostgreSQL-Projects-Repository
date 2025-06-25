ALTER TABLE album
ALTER COLUMN title TYPE VARCHAR(100);

ALTER TABLE artist
ALTER COLUMN name TYPE VARCHAR(100);

ALTER TABLE customer
ALTER COLUMN company TYPE VARCHAR(100);


-- 1. Artist name longer than 30 characters
ALTER TABLE artist
ALTER COLUMN name TYPE VARCHAR(100);

-- 2. Album title longer than 30 characters
ALTER TABLE album
ALTER COLUMN title TYPE VARCHAR(100);

-- 3. Track name and composer too short
ALTER TABLE track
ALTER COLUMN name TYPE VARCHAR(100),
ALTER COLUMN composer TYPE VARCHAR(100);

-- 4. Emails longer than 30 characters
ALTER TABLE employee
ALTER COLUMN email TYPE VARCHAR(100);

ALTER TABLE customer
ALTER COLUMN email TYPE VARCHAR(100);

-- 5. Company name too long
ALTER TABLE customer
ALTER COLUMN company TYPE VARCHAR(100);

-- 6. Address columns
ALTER TABLE customer
ALTER COLUMN address TYPE VARCHAR(120);

ALTER TABLE employee
ALTER COLUMN address TYPE VARCHAR(120);

-- 7. Phone and fax should not be INT
ALTER TABLE customer
ALTER COLUMN phone TYPE VARCHAR(30),
ALTER COLUMN fax TYPE VARCHAR(30);

-- 8. Postal code might contain characters
ALTER TABLE customer
ALTER COLUMN postal_code TYPE VARCHAR(20);

-- 9. Fix unit_price and quantity in invoice_line
ALTER TABLE invoice_line
ALTER COLUMN unit_price TYPE NUMERIC(8,2) USING unit_price::NUMERIC,
ALTER COLUMN quantity TYPE INTEGER USING quantity::INTEGER;





CREATE TABLE employee(
employee_id VARCHAR(50) PRIMARY KEY,
last_name CHAR(50),
first_name CHAR(50),
title VARCHAR(50),
reports_to VARCHAR(30),
levels VARCHAR(10),
birthdate TIMESTAMP,
hire_date TIMESTAMP,
address VARCHAR(120),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(30),
postal_code VARCHAR(30),
phone VARCHAR(30),
fax VARCHAR(30),
email VARCHAR(30));

CREATE TABLE customer(
customer_id VARCHAR(30) PRIMARY KEY,
first_name CHAR(30),
last_name CHAR(30),
company VARCHAR(30),
address VARCHAR(30),
city VARCHAR(30),
state VARCHAR(30),
country VARCHAR(30),
postal_code INT8,
phone INT,
fax INT,
email VARCHAR(30),
support_rep_id VARCHAR(30));

CREATE TABLE invoice(
invoice_id VARCHAR(30) PRIMARY KEY,
customer_id VARCHAR(30),
invoice_date TIMESTAMP,
billing_address VARCHAR(120),
billing_city VARCHAR(30),
billing_state VARCHAR(30),
billing_country VARCHAR(30),
billing_postal VARCHAR(30),
total FLOAT8);

CREATE TABLE invoice_line(
invoice_line_id VARCHAR(50) PRIMARY KEY,
invoice_id VARCHAR(30),
track_id VARCHAR(30),
unit_price VARCHAR(30),
quantity VARCHAR(30));

CREATE TABLE track (
    track_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    album_id VARCHAR(30),
    media_type_id VARCHAR(30),
    genre_id VARCHAR(30),
    composer VARCHAR(100),
    milliseconds BIGINT,
    bytes BIGINT,
    unit_price NUMERIC(8,2)
);

ALTER TABLE track
ALTER COLUMN composer TYPE TEXT;




CREATE TABLE playlist(
playlist_id VARCHAR(50) PRIMARY KEY,
name  VARCHAR(30));

CREATE TABLE playlist_track (
    playlist_id VARCHAR(50),
    track_id VARCHAR(50),
    PRIMARY KEY (playlist_id, track_id)
);


CREATE TABLE artist(
artist_id VARCHAR(50) PRIMARY KEY,
name  VARCHAR(30)); 

CREATE TABLE album(
album_id VARCHAR(50) PRIMARY KEY,
title  VARCHAR(30),
artist_id  VARCHAR(30));

CREATE TABLE media_type(
media_type_id VARCHAR(50) PRIMARY KEY,
name VARCHAR(30));

CREATE TABLE genre(
genre_id VARCHAR(50) PRIMARY KEY,
name VARCHAR(30));

------------------------------------------------------------------------------------------
------------------✅ Easy Level Questions (10)------------------

/* Q1: Who is the senior most employee based on job title? */
SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1;

/* Q2: Which countries have the most Invoices? */
SELECT COUNT(*) AS c, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY c DESC;

/* Q3: What are top 3 values of total invoice? */
SELECT total 
FROM invoice
ORDER BY total DESC
LIMIT 3;

/* Q4: Which city has the highest sum of invoice totals? */
SELECT billing_city, SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1;

/* Q5: Who is the best customer (most money spent)? */
SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;

/* Q6: List all unique billing countries. */
SELECT DISTINCT billing_country FROM invoice;

/* Q7: How many customers do we have in total? */
SELECT COUNT(*) AS total_customers FROM customer;

/* Q8: What is the average invoice total? */
SELECT AVG(total) AS avg_invoice FROM invoice;

/* Q9: What is the total revenue? */
SELECT SUM(total) AS total_revenue FROM invoice;

/* Q10: Which customer has made the most purchases (by number of invoices)? */
SELECT customer.customer_id, first_name, last_name, COUNT(*) AS num_invoices
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY num_invoices DESC
LIMIT 1;


----------------------------🔶 Moderate Level Questions (10)----------------------------


/* Q1: Email, first name, last name, & genre of all Rock listeners (Method 2) */
SELECT DISTINCT email, first_name, last_name, genre.name AS genre
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name = 'Rock'
ORDER BY email;

/* Q2: Top 10 Rock bands by number of songs */
SELECT artist.artist_id, artist.name, COUNT(track.track_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name = 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

/* Q3: Tracks longer than average length */
SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

/* Q4: List the top 5 cities with the most customers */
SELECT city, COUNT(*) AS num_customers
FROM customer
GROUP BY city
ORDER BY num_customers DESC
LIMIT 5;

/* Q5: Which albums have more than 10 tracks? */
SELECT album.title, COUNT(track.track_id) AS track_count
FROM album
JOIN track ON album.album_id = track.album_id
GROUP BY album.album_id
HAVING COUNT(track.track_id) > 10
ORDER BY track_count DESC;

/* Q6: List the 5 most purchased tracks */
SELECT track.name, SUM(invoice_line.quantity) AS total_purchases
FROM track
JOIN invoice_line ON track.track_id = invoice_line.track_id
GROUP BY track.track_id
ORDER BY total_purchases DESC
LIMIT 5;

/* Q7: Count how many tracks there are per genre */
SELECT genre.name, COUNT(track.track_id) AS track_count
FROM genre
JOIN track ON genre.genre_id = track.genre_id
GROUP BY genre.genre_id
ORDER BY track_count DESC;

SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spent
FROM invoice
JOIN customer USING (customer_id)
GROUP BY customer.customer_id, first_name, last_name
HAVING SUM(total) > 50
ORDER BY total_spent DESC;

/* Q9: List all customers and their total number of tracks purchased */
SELECT customer.customer_id, first_name, last_name, COUNT(invoice_line.track_id) AS tracks_bought
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
GROUP BY customer.customer_id
ORDER BY tracks_bought DESC;

/* Q10: Average number of tracks per invoice */
SELECT AVG(track_count) AS avg_tracks_per_invoice
FROM (
    SELECT COUNT(*) AS track_count
    FROM invoice_line
    GROUP BY invoice_id
) AS sub;



-------------------------------🔷 Advanced Level Questions (10)-------------------------------

/* Q1: How much has each customer spent on the best-selling artist? */
WITH best_selling_artist AS (
	SELECT artist.artist_id, artist.name AS artist_name,
		   SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY artist.artist_id
	ORDER BY total_sales DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
       SUM(il.unit_price * il.quantity) AS amount_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album a ON a.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = a.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC;

/* Q2: Most popular genre per country */
WITH genre_sales AS (
	SELECT customer.country, genre.name, COUNT(*) AS purchases,
	       ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(*) DESC) AS rn
	FROM customer
	JOIN invoice ON customer.customer_id = invoice.customer_id
	JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
	JOIN track ON invoice_line.track_id = track.track_id
	JOIN genre ON track.genre_id = genre.genre_id
	GROUP BY customer.country, genre.name
)
SELECT country, name AS top_genre, purchases
FROM genre_sales
WHERE rn = 1;

/* Q3: Top customer per country by amount spent */
WITH spending AS (
	SELECT customer.customer_id, customer.first_name, customer.last_name, billing_country,
		   SUM(total) AS amount_spent,
		   ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS rn
	FROM invoice
	JOIN customer ON invoice.customer_id = customer.customer_id
	GROUP BY customer.customer_id, billing_country
)
SELECT * FROM spending WHERE rn = 1;

/* Q4: Customers who bought from more than 5 different genres */
SELECT customer.customer_id, first_name, last_name, COUNT(DISTINCT genre.genre_id) AS genre_count
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY customer.customer_id
HAVING COUNT(DISTINCT genre.genre_id) > 5;

/* Q5: Invoices that contain tracks from more than 3 genres */
SELECT invoice.invoice_id, COUNT(DISTINCT genre.genre_id) AS genres_in_invoice
FROM invoice
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY invoice.invoice_id
HAVING COUNT(DISTINCT genre.genre_id) > 3;

/* Q6: Top 3 customers with the most money spent on Rock genre */
SELECT customer.customer_id, first_name, last_name, SUM(invoice_line.unit_price * invoice_line.quantity) AS rock_spent
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock'
GROUP BY customer.customer_id
ORDER BY rock_spent DESC
LIMIT 3;

/* Q7: Month-wise total revenue */
SELECT DATE_TRUNC('month', invoice_date) AS month, SUM(total) AS revenue
FROM invoice
GROUP BY month
ORDER BY month;

/* Q8: Average spending per customer */
SELECT customer_id, AVG(total) AS avg_spending
FROM invoice
GROUP BY customer_id
ORDER BY avg_spending DESC;

/* Q9: Artist with the longest average song duration */
SELECT artist.name, AVG(track.milliseconds) AS avg_duration
FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON album.album_id = track.album_id
GROUP BY artist.artist_id
ORDER BY avg_duration DESC
LIMIT 1;

/* Q10: Customers who bought at least 1 track from every genre */
SELECT customer_id, first_name, last_name
FROM customer
WHERE NOT EXISTS (
	SELECT genre_id FROM genre
	EXCEPT
	SELECT DISTINCT track.genre_id
	FROM invoice
	JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
	JOIN track ON invoice_line.track_id = track.track_id
	WHERE invoice.customer_id = customer.customer_id
);




