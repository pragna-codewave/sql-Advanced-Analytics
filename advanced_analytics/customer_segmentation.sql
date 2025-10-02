/*Group customers info into three segment based on their spending behavior:
   -VIP: Customers with at least 12 months of history and spending more than 5,000
   -Regular: Customers with at least 12 months of history but 5,000 or less
   -New: Customers with a lifespan less than 12 months
And find the total number of customers by each group
*/
With spending as(
SELECT 
c.customer_key,
SUM(f.sales_amount) as total_spending,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
DATEDIFF(month,MIN(order_date),MAX(order_date)) as months
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key)

SELECT 
report,
COUNT(customer_key) as TotalCustomers
FROM(
SELECT 
customer_key,
CASE WHEN months >= 12 and total_spending > 5000 THEN 'VIP'
     WHEN months >= 12 and total_spending <= 5000 THEN 'Regular'
     WHEN months < 12  THEN 'New'
END report
FROM spending)t
GROUP BY report
