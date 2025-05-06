-- Date Exploration

-- How many years of sale are available
SELECT 
  min(order_date) AS first_order_date,
  max(order_date) AS last_order_date,
  YEAR(max(order_date)) - YEAR(min(order_date)) AS order_range_years
FROM gold_fact_sales;

SELECT 
  min(order_date) AS first_order_date,
  max(order_date) AS last_order_date,
  TIMESTAMPDIFF(MONTH, min(order_date), max(order_date)) AS order_range_months
FROM gold_fact_sales;

-- find the youngest and the oldest customer
select min(birthdate) as oldest_birthdate,
max(birthdate) as youngest_birthdate
from gold_dim_customers;

select min(birthdate) as oldest_birthdate,
max(birthdate) as youngest_birthdate,
timestampdiff(year,min(birthdate),now()) as oldest_age
from gold_dim_customers;
