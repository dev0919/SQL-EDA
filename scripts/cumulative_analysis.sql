-- Cumulative Analysis

-- Calculate the total sales per month 
-- and the running total of sales over time 
select 
order_date,
total_sales,
sum(total_sales) over (partition by order_date order by order_date) as running_total_sales
from
(
	select 
	date_format(order_date,'%Y-%m' ) as order_date,
	sum(sales_amount) as total_sales
	from gold_fact_sales
	where order_date is not NULL
    group by date_format(order_date,'%Y-%m' )
    ) t;

select 
order_date,
total_sales,
sum(total_sales) over ( order by order_date) as running_total_sales,
avg(total_sales) over ( order by order_date) as moving_average_price
from
(
	select 
	date_format(order_date,'%Y-%m' ) as order_date,
	sum(sales_amount) as total_sales
	from gold_fact_sales
	where order_date is not NULL
    group by date_format(order_date,'%Y-%m' )
    ) t;
