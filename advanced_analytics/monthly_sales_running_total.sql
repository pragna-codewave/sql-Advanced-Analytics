-- Calculate the total sales per month
--and the running total of sales over time

SELECT 
    Month_,
    TotalSales,
    SUM(TotalSales) OVER(ORDER BY MonthOrder) AS RunningTotal
FROM (
    SELECT
        FORMAT(order_date, 'MMM') AS Month_,
        SUM(sales_amount) AS TotalSales,
        MONTH(order_date) AS MonthOrder
    FROM gold.fact_sales
    GROUP BY FORMAT(order_date, 'MMM'), MONTH(order_date)
) t
ORDER BY t.MonthOrder;
