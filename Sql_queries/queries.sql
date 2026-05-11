-- creating database
create database Olist;

-- checking no. of records in table
SELECT count(*) FROM olist.final_data;

-- Data
SELECT * FROM olist.final_data;

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

-- impact of delayed deliveries on reviews
SELECT review_score , AVG(delivery_delay) AS avg_delay, COUNT(*) AS Total_orders 
FROM final_data
WHERE review_score IS NOT NULL AND delivery_delay>0
GROUP BY review_score
ORDER BY review_score;

-- On-time vs Late Delivries
WITH delivery_count AS(
						SELECT 
							CASE 
								WHEN delivery_delay >0 THEN "Late"
								ELSE "On-time"
							END AS delivery_status,
							COUNT(*) AS total_orders
						FROM final_data
                        GROUP BY delivery_status
                        )
SELECT delivery_status , total_orders ,
		ROUND(total_orders*100.0/SUM(total_orders) OVER(),2 )AS Percentage
FROM delivery_count;

-- 10 Best performing states
SELECT 
    customer_state, SUM(total_price) AS Revenue,
    COUNT(DISTINCT order_id) AS Total_Orders,
    ROUND(AVG(total_price), 2) AS Avg_Order_Value
FROM final_data
GROUP BY customer_state
ORDER BY Revenue DESC
LIMIT 10;

-- Monthly revenue growth percentage
SELECT month(order_purchase_timestamp) as Month_num , order_month AS Month , ROUND(SUM(total_price),2) AS Revenue
FROM final_data
WHERE total_price IS NOT NULL 
GROUP BY Month
ORDER BY Month_num;

-- Delivery days vs total_price
SELECT 
    CASE 
        WHEN total_price < 100 THEN 'Low Value'
        WHEN total_price BETWEEN 100 AND 500 THEN 'Medium Value'
        ELSE 'High Value'
    END AS price_category,

    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,

    COUNT(*) AS total_orders

FROM final_data

WHERE delivery_days IS NOT NULL

GROUP BY price_category;