/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- -- Explore all counries our customers come from

Select distinct country from gold_dim_customers;

-- Explore all major product categories
Select distinct Category,subcategory, product_name from gold_dim_products
order by 1,2,3;
