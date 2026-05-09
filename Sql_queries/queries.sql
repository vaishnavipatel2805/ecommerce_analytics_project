-- creating database
create database Olist;

-- checking no. of records in table
SELECT count(*) FROM olist.final_data;

-- table
SELECT * FROM olist.final_data;

-- Revenue

-- Total revenue
SELECT SUM(total_price) AS Total_revenue
FROM final_data;

-- monthly revenue
SELECT order_month , SUM(total_price) AS Revenue
FROM final_data
GROUP BY order_month
ORDER BY Revenue DESC;

-- review score analysis
SELECT review_score , COUNT(*) AS Count
FROM final_data
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY Count DESC;

-- 	most preferred payemnt method
SELECT payment_type , COUNT(order_id) AS count
FROM final_data
WHERE payment_type IS NOT NULL
GROUP BY payment_type;

