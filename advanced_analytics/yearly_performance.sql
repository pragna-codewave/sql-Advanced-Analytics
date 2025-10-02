/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year sales*/

WITH yearly_sales as(
SELECT 
Year(f.order_date) as Order_year,
p.product_name,
SUM(f.sales_amount) as currentsales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date is NOT NULL
GROUP BY p.product_name,YEAR(f.order_date)
)
SELECT
order_year,
product_name,
CurrentSales,
AVG(currentsales) OVER(Partition BY product_name ORDER BY order_year) as avgSales,
CurrentSales - AVG(currentsales) OVER(Partition BY product_name) as diff,
CASE WHEN CurrentSales - AVG(currentsales) OVER(Partition BY product_name) > 0 THEN 'AboveAvg'
     WHEN CurrentSales - AVG(currentsales) OVER(Partition BY product_name) < 0 THEN 'BelowAvg'
     ELSE 'Avg'
END avgdiff,
LAG(CurrentSales) OVER(Partition By product_name Order By order_year)as previous_year,
CurrentSales - LAG(CurrentSales) OVER(Partition By product_name Order By order_year) as diff_py,
CASE WHEN CurrentSales - LAG(CurrentSales) OVER(Partition By product_name Order By order_year) > 0 THEN 'Increse'
     WHEN CurrentSales - LAG(CurrentSales) OVER(Partition By product_name Order By order_year) < 0 THEN 'Decrese'
     ELSE 'Avg'
END py_sales
FROM yearly_sales
