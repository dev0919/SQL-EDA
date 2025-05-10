/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- find the total sales
select sum(sales_amount) as total_sales from gold_fact_sales;

-- find no of items that are sold
select sum(sls_Quantity) as total_quantity from gold_fact_sales;


-- find the average selling price
select avg(price) as avg_price from gold_fact_sales;

-- find the total number of orders
select count(order_number) as total_orders from gold_fact_sales;
select count(distinct order_number) as total_orders from gold_fact_sales;

-- find the total number of products
select count(product_name) as total_products from gold_dim_products;

-- find the total number of customers
select count(customer_key) as total_customers from gold_dim_customers;

-- find the total number of customers that has placed an order
select count(distinct customer_key) as total_customers from gold_fact_sales;

-- generate a report that shows all key metrics of the business
select 'total sales' as measure_name, sum(sales_amount) as measure_value from gold_fact_sales
union all
select 'total quantity', sum(sls_quantity) from gold_fact_sales
union all
select 'average price', avg(price) from gold_fact_sales
union all
select 'total orders', count(distinct order_number) from gold_fact_sales
union all
select 'total products', count(distinct product_name) from gold_dim_products
union all
select 'total customers', count(customer_key) from gold_dim_customers;
