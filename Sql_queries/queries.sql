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

-- Freight Cost Analysis
SELECT 
    ROUND(AVG(freight_value), 2) AS avg_freight,
    ROUND(AVG(price), 2) AS avg_product_price
FROM final_data;

-- State vs Revenue vs Avg Delivery Days
SELECT 
    customer_state,
    ROUND(SUM(total_price), 2) AS Revenue,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    COUNT(DISTINCT order_id) AS total_orders
FROM final_data
GROUP BY customer_state
ORDER BY Revenue DESC
LIMIT 10;

-- Repeat Customer Analysis
WITH total_orders AS(
                    SELECT 
                        customer_unique_id ,
                        COUNT(DISTINCT(order_id)) AS orders
                        FROM final_data
                        GROUP BY customer_unique_id
                            
)
SELECT 
    CASE 
        WHEN orders = 1 
        THEN "One time customer"
        ELSE "Repeat customer"
    END AS customer_type,
    COUNT(*) AS total_customers
FROM total_orders
GROUP BY customer_type

-- Customer Lifetime Value (CLV)
WITH order_value AS (

    SELECT 
        order_id,
        customer_unique_id,
        MAX(total_price) AS order_total
    FROM final_data
    WHERE total_price IS NOT NULL
    GROUP BY order_id, customer_unique_id
)

SELECT 
    customer_unique_id,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(order_total), 2) AS customer_lifetime_value,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM order_value
GROUP BY customer_unique_id
ORDER BY customer_lifetime_value DESC;















