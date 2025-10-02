/*
===============================================================
Customer Report
===============================================================
Purpose:
   - This report consolidates key customer metrics and behaviors

Highlights:
   1.Gather essential fields such as names,ages and transaction details
   2.Segment customers into categories (VIP,Regular,New) and age groups.
   3.Aggregates customer-level metrics:
     - total orders
     - total sales
     - total quantity purchased
     - total products
     - lifespan (in months)
   4.Calculate valuable KPIs:
     - recency (months since last order)
     - average order value
     - average monthly spend
===============================================================
*/


CREATE VIEW gold.report_products as
With customer_details as(
SELECT
c.customer_key,
c.customer_number,
CONCAT(c.first_name,'',c.last_name) as customer_name,
SUM(f.sales_amount) as Totalsales,
SUM(f.quantity) AS total_quantity,
MAX(f.order_date) as first_order,
MIN(f.order_date) as last_order,
DATEDIFF(month,MIN(order_date),MAX(order_date)) as months,
DATEDIFF(year,c.birthdate,GETDATE()) as Age,
COUNT(DISTINCT f.order_number) AS total_orders,
COUNT(DISTINCT f.product_key) as total_products
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
GROUP BY c.customer_key, c.customer_number, c.first_name, c.last_name, c.birthdate
)

SELECT
customer_key,
customer_name,
total_orders,
total_quantity,
total_products,
months,
Totalsales,
CASE WHEN months >= 12 and Totalsales > 5000 THEN 'VIP'
     WHEN months >= 12 and Totalsales <= 5000 THEN 'Regular'
     WHEN months < 12  THEN 'New'
END report,
age,
CASE WHEN age < 25 THEN 'young'
     WHEN age > 50 THEN 'old'
     ELSE 'Middle'
END age_report,
DATEDIFF(year,last_order, GETDATE()) as recency,
(Totalsales / total_products) as AvgOrderValue,
CASE WHEN months = 0 THEN 0
     ELSE Totalsales / months 
END AvgMonthlySpend
FROM customer_details
