-- Analyse sales performance over time
-- Quick Date Functions
select
order_date,
sum(sales_amount) as total_sales
from gold_fact_sales
where order_date is not NULL
group by order_date
order by order_date ;


select
year(order_date),
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(sls_quantity) as total_quantity
from gold_fact_sales
where order_date is not NULL
group by year(order_date)
order by year(order_date);

select
year(order_date) as order_year,
month(order_date) as order_month,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(sls_quantity) as total_quantity
from gold_fact_sales
where order_date is not NULL
group by month(order_date), year(order_date)
order by month(order_date), year(order_date); 

select
date_format(order_date,'%Y-%m' ) as order_date,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(sls_quantity) as total_quantity
from gold_fact_sales
where order_date is not NULL
group by date_format(order_date,'%Y-%m' )
order by date_format(order_date,'%Y-%m' );

select
DATE_FORMAT(order_date, '%Y-%b') AS order_month,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(sls_quantity) as total_quantity
from gold_fact_sales
where order_date is not NULL
group by DATE_FORMAT(order_date, '%Y-%b') 
order by DATE_FORMAT(order_date, '%Y-%b');
