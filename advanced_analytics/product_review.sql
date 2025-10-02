/*
===============================================================
Product Report
===============================================================
Purpose:
   - This report consolidates key product metrics and behaviors

Highlights:
   1.Gather essential fields such as product name,category,subcategory and cost
   2.Segment customers into categories (VIP,Regular,New) and age groups.
   3.Aggregates customer-level metrics:
     - total orders
     - total sales
     - total quantity sold
     - total products
     - lifespan (in months)
   4.Calculate valuable KPIs:
     - recency (months since last sale)
     - average order revenue
     - average monthly revenue
===============================================================
*/
CREATE VIEW gold.report_products as
WITH product_details as(
SELECT 
p.product_key,
p.product_id,
p.product_name,
p.category,
p.subcategory,
p.cost,
COUNT(f.order_number) as TotalOrders,
COUNT(distinct f.customer_key) as TotalCustomers,
SUM(f.sales_amount) as totalSales,
SUM(f.quantity) as QuantitySold,
MAX(f.order_date) as first_order,
MIN(f.order_date) as last_order,
DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date is not null
GROUP BY p.product_name,
p.category,
p.subcategory,
p.cost,
p.product_key,
p.product_id)

SELECT
product_key,
product_id,
product_name,
category,
subcategory,
cost,
TotalOrders,
TotalCustomers,
totalSales,
CASE WHEN totalSales < 100000 THEN 'Low-performer'
     WHEN totalSales < 1000000 THEN 'High-performer'
     ELSE 'Mid-Range'
END report,
QuantitySold,
lifespan,
 DATEDIFF(month, last_order, GETDATE()) AS recency_months,
 totalSales / NULLIF(TotalOrders, 0)  AS avg_order_revenue,
 totalSales  / NULLIF(lifespan, 0)  AS avg_monthly_revenue
FROM product_details 
