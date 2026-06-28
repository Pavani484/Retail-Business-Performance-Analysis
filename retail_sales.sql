CREATE DATABASE retail_analysis;
USE retail_analysis;




CREATE TABLE retail_sales (
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    state VARCHAR(100),
    country VARCHAR(100),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(100),
    product_name VARCHAR(255),
    sales DECIMAL(12,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,3),
    shipping_cost DECIMAL(10,2),
    order_priority VARCHAR(20),
    year INT
);
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
DROP TABLE IF EXISTS retail_sales_raw;

CREATE TABLE retail_sales_raw (
    order_id VARCHAR(30),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    state VARCHAR(100),
    country VARCHAR(100),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(100),
    product_name VARCHAR(255),
    sales VARCHAR(30),
    quantity VARCHAR(20),
    discount VARCHAR(20),
    profit VARCHAR(30),
    shipping_cost VARCHAR(30),
    order_priority VARCHAR(20),
    year VARCHAR(10)
);

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SuperStoreOrders.csv'
INTO TABLE retail_sales_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM retail_sales_raw;

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    state VARCHAR(100),
    country VARCHAR(100),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(100),
    product_name VARCHAR(255),
    sales DECIMAL(15,2),
    quantity INT,
    discount DECIMAL(10,2),
    profit DECIMAL(15,3),
    shipping_cost DECIMAL(15,2),
    order_priority VARCHAR(20),
    year INT
);

INSERT INTO retail_sales
SELECT
order_id,
STR_TO_DATE(order_date,'%d-%m-%Y'),
STR_TO_DATE(ship_date,'%d-%m-%Y'),
ship_mode,
customer_name,
segment,
state,
country,
market,
region,
product_id,
category,
sub_category,
product_name,
REPLACE(sales,',',''),
quantity,
discount,
REPLACE(profit,',',''),
REPLACE(shipping_cost,',',''),
order_priority,
year
FROM retail_sales_raw;

SELECT COUNT(*) FROM retail_sales;


SELECT
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales;


SELECT
    category,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;


SELECT
    category,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin
FROM retail_sales
GROUP BY category
ORDER BY profit_margin DESC;


SELECT
    sub_category,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales
GROUP BY sub_category
ORDER BY total_profit DESC
LIMIT 10;


SELECT
    sub_category,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;


SELECT
    MONTH(order_date) AS month_num,
    MONTHNAME(order_date) AS month_name,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_num;

SELECT
    region,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales
GROUP BY region
ORDER BY total_profit DESC;

SELECT
    market,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales
GROUP BY market
ORDER BY total_profit DESC;

SELECT
    ROUND(discount,2) AS discount_rate,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales
GROUP BY discount
ORDER BY discount;
