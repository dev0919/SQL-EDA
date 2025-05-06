-- Database Exploration

-- Explore all objects in the database
select * from information_schema.tables 
WHERE table_schema = 'DataWarehouse';

-- Explore all columns in the database
select * from information_schema.columns 
WHERE table_schema = 'DataWarehouse';

-- Explore all columns in the database for a specific table
select * from information_schema.columns 
WHERE table_schema = 'DataWarehouse'
and table_name='gold_dim_customers';
