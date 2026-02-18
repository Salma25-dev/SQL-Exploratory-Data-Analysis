1. DATA EXPLORATION: 
to get an Overview of the database
QUERY:
// to get an overview of all tables
SELECT * FROM INFORMATION_SCHEMA.TABLES

// to get an overview of all columns
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

// to get an overview of columns of one table (customers)
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name ='dim_customers'

2. DIMENSIONS EXPLORATION: 
// Explore all countries our customers come from (First little Insight about our Business)
SELECT DISTINCT country FROM dim_customers

// Explore all categories (The major dimensions)
SELECT DISTINCT category FROM dim_products
SELECT DISTINCT category, subcategory, product_name FROM dim_products

3. DATE EXPLORATION: to indentify the earliest and the latest date
// Find the date of the first and the last Order
SELECT MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date) ) AS order_range_years
FROM fact_sales

// Find the youngest and the oldest customer, "DATEDIFF" function shows the age for the  youngest and the oldest customer

SELECT MIN(birthdate) AS oldest_birthdate,
DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_birthdate,
DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM dim_customers
 

4. MEASURES EXPLORATION:
Calculate the key metric of the business (Big Numbers)
// Find total of sales
SELECT SUM(sales_amount) AS total_sales
FROM fact_sales

// Find how many items are sold
SELECT SUM(quantity) AS total_quantity
FROM fact_sales

// Find the average selling price
SELECT AVG(price) AS average_price
FROM fact_sales

// Find the total number of Orders
SELECT COUNT(DISTINCT order_number) AS total_orders
FROM fact_sales

// Find the total number of products
SELECT COUNT(product_id) AS total_products FROM dim_products
SELECT COUNT(DISTINCT product_id) AS total_products FROM dim_products

// Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM dim_customers

// Find the total number of customers that has places an order
SELECT COUNT( DISTINCT customer_key) AS total_customers FROM fact_sales

Generate Report that shows all key metrics of the business: (to put all big Numbers in one query to understand the business)

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value
FROM fact_sales
UNION All
SELECT 'Total Quantity', SUM(quantity) FROM fact_sales
UNION All 
SELECT 'Average Price', AVG(price) FROM fact_sales
UNION ALL 
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM fact_sales
UNION ALL 
SELECT 'Total Products', COUNT(DISTINCT product_id) FROM dim_products
UNION ALL 
SELECT 'Total Customers', COUNT(customer_key) FROM dim_customers

 

3. MAGNITUDE ANALYSIS: I compare the meseaure values by categories 
// Find total customers by countries 
SELECT country, COUNT(customer_id) AS  total_customers
FROM dim_customers
GROUP BY country 
ORDER BY total_customers DESC

// Find total customers by gender
SELECT gender, COUNT(customer_id) AS  total_customers
FROM dim_customers
GROUP BY gender 
ORDER BY total_customers DESC

// Find total products by category
SELECT category, COUNT(product_key) AS  total_products
FROM dim_products
GROUP BY category 
ORDER BY total_products DESC

// Find the average costs by category
SELECT category, AVG(cost) AS  average_cost
FROM dim_products
GROUP BY category 
ORDER BY average_cost DESC

// Find the total revenue for each category 
SELECT p.category, SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN
dim_products p
ON p.product_key = f.product_key
GROUP BY p.category 
ORDER BY total_revenue DESC

// Find the total revenue for each customer
SELECT c.customer_key, c.first_name, c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key= c.customer_key
GROUP BY
c.customer_key,
c.first_name, 
c.last_name
ORDER BY total_revenue DESC

// Find the total sold items for each country
SELECT c.country, SUM(f.quantity) AS total_sold_items
FROM fact_sales f
LEFT JOIN dim_customers c
ON c.customer_key= f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC


4. Ranking Analysis: Order the values of dimensions by measure
// Which 5 products generate the highest revenue?
SELECT TOP 5
p.product_name, SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_products p 
ON f.product_key= p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

// What are the 5 worst performing products in terms of sales?
SELECT TOP 5 
p.product_name, SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_products p 
ON f.product_key= p.product_key
GROUP BY p.product_name
ORDER BY total_revenue

// What are the  top 10 customers who have generated the highest revenue?
SELECT TOP 10
c.customer_key, 
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key= c.customer_key
GROUP BY
c.customer_key,
c.first_name, 
c.last_name
ORDER BY total_revenue DESC

// What are the  3 customers with the fewest orders placed?
SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT f.order_number) AS total_orders
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key= c.customer_key
GROUP BY
c.customer_key,
c.first_name, 
c.last_name
ORDER BY total_orders 


