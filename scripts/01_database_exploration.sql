/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

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
