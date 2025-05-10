/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
DROP VIEW IF EXISTS gold_report_customers;
CREATE VIEW gold_report_customers AS
WITH base_query as(
/* ---------------------------------------------------
1) Base Query: Retrieves core columns from tables
--------------------------------------------------------*/
select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.sls_quantity,
c.customer_key,
c.customer_number,
concat(c.firstname, ' ', c.lastname) as customer_name,
TIMESTAMPDIFF(year, c.birthdate, now())age
from gold_fact_sales f
LEFT JOIN gold_dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL)

, customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
select 
	customer_key,
	customer_number,
	customer_name,
	age,
	count(DISTINCT order_number) AS total_orders,
	sum(sales_amount) AS total_sales,
	sum(sls_quantity) AS total_quantity,
	count(DISTINCT product_key) AS total_products,
	max(order_date) AS last_order_date,
	timestampdiff(month, min(order_date), max(order_date)) AS lifespan
    from base_query
    group by 
	customer_key,
	customer_number,
	customer_name,
	age
)
select
customer_key,
customer_number,
customer_name,
age,
case 
 when age < 20 then 'Under 20'
 when age between 20 and 29 then '20-29'
 when age between 30 and 39 then '30-39'
 when age between 40 and 49 then '40-49'
 else '50 and above'
 end as age_group,
 case 
  when lifespan >= 12 and total_sales > 5000 then 'VIP'
  when lifespan >= 12 and total_sales <= 5000 then 'Regular'
    else 'New'
end as customer_segment,
last_order_date,
timestampdiff(month, last_order_date, now()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products
lifespan,
-- Compuate average order value (AVO)
case when total_sales = 0 THEN 0
	 else total_sales / total_orders
end as  avg_order_value,
-- Compuate average monthly spend
case when lifespan = 0 THEN total_sales
     else total_sales / lifespan
end as avg_monthly_spend
from customer_aggregation;
