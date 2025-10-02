-- Which category contribute the most to Overall Sales


With Contribution_to_sales as(
SELECT 
p.category,
SUM(f.sales_amount) as Sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key  = f.product_key 
GROUP BY category
)
SELECT 
*,
SUM(Sales) OVER() as TotalSales,
CONCAT(ROUND((CAST(Sales as float) / SUM(Sales) OVER() ) * 100,2) ,'%') as percent_
FROM Contribution_to_sales
ORDER BY Sales DESC
