/*Segment products into cost ranges and
count how many products fall into each segment*/


With product_segments as(
SELECT 
product_key,
product_name,
category,
cost,
CASE WHEN cost < 500 THEN 'Low_Price'
     WHEN cost > 1500 THEN 'High_Price'
     ELSE 'Avg_Price'
END cost_range
FROM gold.dim_products)

SELECT 
cost_range,
COUNT(product_key) as total_products
FROM product_segments
GROUP BY cost_range




