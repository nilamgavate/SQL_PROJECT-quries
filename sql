1. //Senior Most Employee Based on Job Title.

SELECT 
    * 
FROM 
    employee 
ORDER BY 
    levels DESC 
LIMIT 1;

2. //Countries with the Most Invoices.

SELECT 
    COUNT(billing_country) AS invoice_count, 
    billing_country AS most_invoices_country 
FROM 
    invoice 
GROUP BY 
    billing_country 
ORDER BY 
    invoice_count DESC;

 3. //Top 3 Values of Total Invoice.

SELECT 
    * 
FROM 
    invoice 
ORDER BY 
    total DESC 
LIMIT 3;

4. // City with the Best Customers (Highest Sum of Invoice Totals).

SELECT 
    SUM(total) AS invoice_total, 
    billing_city 
FROM 
    invoice 
GROUP BY 
    billing_city 
ORDER BY 
    invoice_total DESC 
LIMIT 1;

5. // Best Customer (Customer Who Spent the Most Money)

SELECT 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name, 
    SUM(invoice.total) AS spend_money 
FROM 
    customer 
    JOIN invoice ON customer.customer_id = invoice.customer_id 
GROUP BY 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name 
ORDER BY 
    spend_money DESC 
LIMIT 1;

6.// Rock Music Listeners (Email, First Name, Last Name, & Genre).

SELECT DISTINCT 
    email, 
    first_name, 
    last_name, 
    genre.name AS Genre 
FROM 
    customer 
    JOIN invoice ON invoice.customer_id = customer.customer_id 
    JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id 
    JOIN track ON track.track_id = invoice_line.track_id 
    JOIN genre ON genre.genre_id = track.genre_id 
WHERE 
    genre.name LIKE 'Rock' 
ORDER BY 
    email;

7. // Top 10 Rock Bands (Artist Name and Total Track Count)

SELECT 
    artist.artist_id, 
    artist.name, 
    COUNT(track.track_id) AS number_of_songs 
FROM 
    track 
    JOIN album2 ON album2.album_id = track.album_id 
    JOIN artist ON artist.artist_id = album2.artist_id 
    JOIN genre ON genre.genre_id = track.genre_id 
WHERE 
    genre.name LIKE 'Rock' 
GROUP BY 
    artist.artist_id, 
    artist.name 
ORDER BY 
    number_of_songs DESC 
LIMIT 10;

8. // Tracks Longer than the Average Song Length.

SELECT 
    name, 
    milliseconds 
FROM 
    track 
WHERE 
    milliseconds > (
        SELECT 
            AVG(milliseconds) AS avg_track_length 
        FROM 
            track
    ) 
ORDER BY 
    milliseconds DESC;

9. Amount Spent by Each Customer on Artists.

WITH best_selling_artist AS (
    SELECT 
        artist.artist_id AS artist_id, 
        artist.name AS artist_name, 
        SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales 
    FROM 
        invoice_line 
        JOIN track ON track.track_id = invoice_line.track_id 
        JOIN album2 ON album2.album_id = track.album_id 
        JOIN artist ON artist.artist_id = album2.artist_id 
    GROUP BY 
        artist.artist_id, 
        artist.name 
    ORDER BY 
        total_sales DESC 
    LIMIT 1
) 
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    bsa.artist_name, 
    SUM(il.unit_price * il.quantity) AS amount_spent 
FROM 
    invoice i 
    JOIN customer c ON c.customer_id = i.customer_id 
    JOIN invoice_line il ON il.invoice_id = i.invoice_id 
    JOIN track t ON t.track_id = il.track_id 
    JOIN album2 alb ON alb.album_id = t.album_id 
    JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id 
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    bsa.artist_name 
ORDER BY 
    amount_spent DESC;

10. // Most Popular Music Genre for Each Country.

WITH popular_genre AS (
    SELECT 
        COUNT(invoice_line.quantity) AS purchases, 
        customer.country, 
        genre.name, 
        genre.genre_id, 
        ROW_NUMBER() OVER (PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM 
        invoice_line 
        JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id 
        JOIN customer ON customer.customer_id = invoice.customer_id 
        JOIN track ON track.track_id = invoice_line.track_id 
        JOIN genre ON genre.genre_id = track.genre_id 
    GROUP BY 
        customer.country, 
        genre.name, 
        genre.genre_id 
    ORDER BY 
        customer.country ASC, 
        purchases DESC
) 
SELECT 
    * 
FROM 
    popular_genre 
WHERE 
    RowNo = 1;
11.// Customer Who Spent the Most on Music for Each Country

WITH Customer_with_country AS (
    SELECT 
        customer.customer_id, 
        customer.first_name, 
        customer.last_name, 
        billing_country, 
        SUM(total) AS total_spending, 
        ROW_NUMBER() OVER (PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
    FROM 
        invoice 
        JOIN customer ON customer.customer_id = invoice.customer_id 
    GROUP BY 
        customer.customer_id, 
        customer.first_name, 
        customer.last_name, 
        billing_country 
    ORDER BY 
        billing_country ASC, 
        total_spending DESC
) 
SELECT 
    * 
FROM 
    Customer_with_country 
WHERE 
    RowNo = 1;






