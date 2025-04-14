create database sql_project_p1;

CREATE TABLE retail_sales (
    transactions_id SERIAL PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
select * from retail_sales;
limit 10;

select count(*) from retail_sales

-- finding null values 
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


UPDATE retail_sales
SET
    age = COALESCE(age, (SELECT ROUND(AVG(age)::NUMERIC, 0) FROM retail_sales WHERE age IS NOT NULL)),
    quantity = COALESCE(quantity, 1),
    price_per_unit = COALESCE(price_per_unit, (SELECT ROUND(AVG(price_per_unit)::NUMERIC, 2) FROM retail_sales WHERE price_per_unit IS NOT NULL)),
    cogs = COALESCE(cogs, COALESCE(quantity, 1) * COALESCE(price_per_unit, (SELECT ROUND(AVG(price_per_unit)::NUMERIC, 2) FROM retail_sales WHERE price_per_unit IS NOT NULL))),
    total_sale = COALESCE(total_sale, COALESCE(quantity, 1) * COALESCE(price_per_unit, (SELECT ROUND(AVG(price_per_unit)::NUMERIC, 2) FROM retail_sales WHERE price_per_unit IS NOT NULL))),
    gender = COALESCE(gender, 'Unknown'),
    category = COALESCE(category, 'Misc'),
    sale_time = COALESCE(sale_time, '00:00:00')
WHERE
    age IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    sale_time IS NULL;


select * from retail_sales;

-- data exploration 
-- How many sales we have ? 
select count(*) as total_sale from retail_sales

-- How many customer we have 
select count(distinct customer_id) as total_sale from retail_sales


select distinct category from retail_sales


-- data analysis and business & answers 
-- 1. sql query to retrive all columns for sales made on '2022-11-05'
select * 
from retail_sales
where sale_date = '2022-11-05';

-- 2. sql query to retrive all transactions where the category is "Clothing " and the quantity sold is more than 10 in the month of nov-2022

-- SELECT 
-- 	category,
-- 	sum(quantity)
-- from retail_sales
-- where category = 'Clothing'
-- group by 1

-- -- 2. sql query to retrive all transactions where the category is "Clothing " and the quantity sold is more than 10 in the month of nov-2022

-- SELECT *
-- from retail_sales
-- where category = 'Clothing'
-- 	and
-- 	to_char(sale_date,'YYYY-MM') = '2022-11'
-- group by 1


-- 2. sql query to retrive all transactions where the category is "Clothing " and the quantity sold is more than 4 in the month of nov-2022

SELECT *
from retail_sales
where category = 'Clothing'
	and
	to_char(sale_date,'YYYY-MM') = '2022-11'
	and 
	quantity >= 4

-- 3 query to calculate the total sales (total_sale) for each category.
select 
category,
sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by 1 


-- 4. a sql query tofind the average age of customer who purchased items from the "Beauty " category 
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM 
    retail_sales
WHERE 
    category = 'Beauty'

-- 5. sql query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000

-- 6 sql query to find the total number of transactions (transactions_id) made by each gende in each category 
select 
category,
gender,
count(*) as total_trans
from retail_sales
group by 
category,
gender
order by 1

-- 7. sql query to calculate the average sale for each month . find out best selling month in each year 
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS total_monthly_sales
FROM 
    retail_sales
GROUP BY 
    1, 2


-- or 

SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS total_monthly_sales
FROM 
    retail_sales
GROUP BY 
    1, 2
ORDER BY 
	1, 3 DESC

-- OR

SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS total_monthly_sales,
    AVG(total_sale) AS avg_monthly_sales
FROM 
    retail_sales
GROUP BY 
    1, 2
ORDER BY 
    1, 3 DESC;


-- OR 

SELECT 
    year,
    month,
    avg_monthly_sales,
    RANK() OVER (PARTITION BY year ORDER BY avg_monthly_sales DESC) AS monthly_rank
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_monthly_sales
    FROM 
        retail_sales
    GROUP BY 
        1, 2
) AS monthly_data


-- 8 WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL_SALE

SELECT * FROM retail_sales

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
group by 1
order by 2 desc
limit 5

-- 9. write a sql query form find the number of unique customers who purchased items from each category

SELECT 
	category,
	count(distinct customer_id) as cnt_unique_cs
from retail_sales
group by category

-- 10. A sql query to create each shift and number of order (Example morning < = 12, afternoon betweeen 12 & 17, Evening > 17, evening > 17)

SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales;


-- or 

WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)

SELECT 
    shift,
    COUNT(*) AS total_orders
FROM 
    hourly_sale
GROUP BY 
    shift;



-- SELECT EXTRACT(HOUR FROM CURRENT_TIME)


