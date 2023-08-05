/* Create The Table */
drop table if exists pizza_sales;

-- Set the datestyle first
SET datestyle = "ISO, DMY";

-- Create the pizza_orders table
CREATE TABLE pizza_sales(
    pizza_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_name_id VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    pizza_size CHAR NOT NULL,
    pizza_category VARCHAR NOT NULL,
    pizza_ingredients TEXT NOT NULL,
    pizza_name VARCHAR NOT NULL
);

/* checking the raw Table */
select * from pizza_sales;

/* Importing csv file */
--SET client_encoding = 'ISO_8859_1';
COPY pizza_sales(pizza_id,
    order_id,
    pizza_name_id,
    quantity ,
    order_date,
    order_time,
    unit_price ,
    total_price,
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name)
FROM 'C:\Users\ashiw\Downloads\pizza_sales.csv'
DELIMITER ','
CSV HEADER;

--Total Revenue
SELECT SUM(total_price) AS Total_Revenue 
FROM pizza_sales;

--Average Order Value
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value 
FROM pizza_sales

--Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold 
FROM pizza_sales

--Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales

--Average Pizzas Per Order
SELECT ROUND(ROUND(SUM(quantity),2) / 
ROUND(COUNT(DISTINCT order_id),2),2)
AS Avg_Pizzas_per_order
FROM pizza_sales

--Daily Trend for Total Orders
SELECT TO_CHAR(order_date, 'Day') AS day_of_week, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY day_of_week
ORDER BY EXTRACT(dow FROM MIN(order_date));

--Monthly Trend for Orders
select TO_CHAR(order_date, 'Month') as Month_Name, COUNT(DISTINCT order_id) as Total_Orders
from pizza_sales
GROUP BY Month_Name
ORDER BY EXTRACT(MONTH FROM MIN(order_date));

--% of Sales by Pizza Category
SELECT pizza_category, ROUND(SUM(total_price),2) as total_revenue,
ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales),2) AS PCT
FROM pizza_sales
GROUP BY pizza_category;

--% of Sales by Pizza Size
SELECT pizza_size, ROUND(SUM(total_price),2) as total_revenue,
ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales),2) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

--Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

--Top 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC 
LIMIT 5;

--Top 5 Pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

--Top 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

