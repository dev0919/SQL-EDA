/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
DROP VIEW IF EXISTS gold_report_products;
CREATE VIEW gold_report_products as
with base_query as (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
    select
	    f.order_number,
        f.order_date,
		f.customer_key,
        f.sales_amount,
        f.sls_quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    from gold_fact_sales f
    left join gold_dim_products p
        on f.product_key = p.product_key
    where order_date IS NOT NULL  -- only consider valid sales dates
),

product_aggregations AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
select
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    timestampdiff(month, min(order_date), max(order_date)) AS lifespan,
    max(order_date) AS last_sale_date,
    count(DISTINCT order_number) AS total_orders,
	count(DISTINCT customer_key) AS total_customers,
    sum(sales_amount) AS total_sales,
    sum(sls_quantity) AS total_quantity,
	round(AVG(cast(sales_amount as float) / nullif(sls_quantity, 0)),1) AS avg_selling_price
from base_query

group by
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
select
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	timestampdiff(month, last_sale_date, now()) as recency_in_months,
	case
		when total_sales > 50000 then 'High-Performer'
		when total_sales >= 10000 then 'Mid-Range'
		else 'Low-Performer'
	end as product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	case 
		when total_orders = 0 THEN 0
		else total_sales / total_orders
	end as avg_order_revenue,

	-- Average Monthly Revenue
	case
		when lifespan = 0 then total_sales
		else total_sales / lifespan
	end as avg_monthly_revenue

from product_aggregations
