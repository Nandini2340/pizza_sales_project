-- Create order details table
CREATE TABLE order_details(
order_details_id INT,
order_id INT,
pizza_id VARCHAR(50),
quantity INT
);

SELECT * FROM order_details;

-- create orders table
CREATE TABLE orders(
order_id INT,
date DATE,
time TIME
);

SELECT * FROM orders;

-- create pizza type table
CREATE TABLE pizza_type(
	pizza_type_id VARCHAR(100),
	name VARCHAR(100),
	category VARCHAR(100),
	ingredients TEXT
);

SELECT * FROM pizza_type;

-- create pizzas table 
CREATE TABLE pizzas(
	pizza_id	VARCHAR(100),
	pizza_type_id	VARCHAR(100),
	size TEXT,
	price NUMERIC
);

SELECT * FROM pizzas;

-- Q1) Total no of order placed 
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- Q2) Total revenue generated from pizza sales
SELECT SUM(quantity * price) AS total_renvenue
FROM order_detailS as Ort
JOIN 
pizzas as pi
ON ort.pizza_id = pi.pizza_id;

-- Q3) Highest price pizza
SELECT name, MAX(price) AS highest_value
FROM pizza_type AS pit
JOIN pizzas AS piz
ON pit.pizza_type_id = piz.pizza_type_id
GROUP BY name
ORDER BY MAX(price) DESC
LIMIT 1;

-- Q4) most common pizza size ordered
SELECT size, SUM(quantity) AS pizza_ordered
FROM order_details AS ort
JOIN pizzas AS piz
ON ort.pizza_id = piz.pizza_id
GROUP BY size
ORDER BY SUM(quantity) DESC;

-- Q5) Top 5 most ordered pizza along with their quantity
SELECT name , SUM(quantity)
FROM pizza_type AS pit
JOIN pizzas AS piz
ON pit.pizza_type_id = piz.pizza_type_id
JOIN order_details AS ord
ON ord.pizza_id = piz.pizza_id
GROUP BY name
ORDER BY SUM(quantity) DESC
LIMIT 5;

-- Q6) Total quantity of each pizza category ordered
SELECT category, SUM(quantity) AS order_count
FROM pizza_type AS pit
JOIN pizzas AS piz
ON pit.pizza_type_id = piz.pizza_type_id
JOIN order_details AS ord
ON ord.pizza_id = piz.pizza_id
GROUP BY category
ORDER BY order_count DESC;

-- Q7) The distribution of the order by hour of the day
SELECT Extract(HOUR FROM time) AS hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY hour
ORDER BY hour ASC;

-- Q8) find category wise distribution of pizzas
SELECT category, count(name) 
FROM pizza_type
GROUP BY category;

-- Q9) Group the order by date and calulate the average number oF pizza order per day
SELECT date, SUM(quantity) AS quantity
FROM order_details AS ort
JOIN orders AS ors
ON ort.order_id = ors.order_id
GROUP BY date
ORDER BY date ASC;

-- Q10) TOP 3 most ordered pizza type based on revenue
SELECT name, SUM(quantity * price) AS total_renvenue
FROM order_detailS as Ort
JOIN pizzas as pi
ON ort.pizza_id = pi.pizza_id
JOIN pizza_type AS pit
ON pi.pizza_type_id = pit.pizza_type_id
GROUP BY name
ORDER BY SUM(quantity * price) DESC
LIMIT 3;

-- Q11) Calculate the percentage contribution of each pizza type to total Revenue
SELECT category, 
round(SUM(quantity * price) / (SELECT ROUND(SUM(quantity * price),2) AS total_sales
FROM order_details 
JOIN 
pizzas 
ON pizzas.pizza_id = order_details.pizza_id) * 100, 2) AS Revenue
FROM pizza_type JOIN pizzas 
ON pizza_type.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY Revenue desc;

