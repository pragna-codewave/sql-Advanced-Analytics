-- Analyze sales performance over time
SELECT 
YEAR(order_date) as YearOfSales,
SUM(sales_amount) Sales,
COUNT(distinct customer_key) as TotalCustomers,
SUM(quantity) as TotalQuantity
FROM gold.fact_sales
WHERE YEAR(Order_date) IS NOT NULL
GROUP BY YEAR(order_date)
Order BY YEAR(order_date)


