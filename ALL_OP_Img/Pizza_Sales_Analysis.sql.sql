/* Phase 1: Foundation & Inspection */

-- 1. Install IDC_Pizza.dump as IDC_Pizza server
CREATE DATABASE IDC_pizza
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY, 
    name VARCHAR(100),           
    category VARCHAR(50),                  
    ingredients TEXT );

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,  
    pizza_type_id VARCHAR(50) REFERENCES pizza_types(pizza_type_id),
    size VARCHAR(10),                   
    price NUMERIC(5, 2)   );

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    date DATE,
    time TIME WITHOUT TIME ZONE  );
    
CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    pizza_id VARCHAR(50) REFERENCES pizzas(pizza_id),
    quantity INT  );

-- Then insertion of data into the tables

-- 2. List all unique pizza categories (DISTINCT).
SELECT DISTINCT
    (category)
FROM
    pizza_types;

-- 3. Display pizza_type_id, name, and ingredients, replacing NULL ingredients with "Missing Data". Show first 5 rows.
SELECT 
    pizza_type_id,
    name,
    COALESCE(ingredients, 'Missing Data') AS ingredients
FROM
    pizza_types
LIMIT 5;

-- 4. Check for pizzas missing a price (IS NULL).
SELECT 
    *
FROM
    pizzas
WHERE
    price IS NULL;





/*  Phase 2: Filtering & Exploration */

-- 1. Orders placed on '2015-01-01' (`SELECT` + `WHERE`).
SELECT 
    *
FROM
    orders
WHERE
    date = '2015-01-01';

-- 2. List pizzas with price descending.
SELECT 
    pt.name, pt.category, p.size, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC;

-- 3. Pizzas sold in sizes 'L' or 'XL'.
SELECT 
    pt.name, pt.category, p.size, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
WHERE
    p.size = 'L' OR p.size = 'XL';

-- 4. Pizzas priced between $15.00 and $17.00.
SELECT 
    *
FROM
    pizzas
WHERE
    price BETWEEN 15.00 AND 17.00;

-- 5. Pizzas with "Chicken" in the name.
SELECT 
    name
FROM
    pizza_types
WHERE
    name LIKE '%Chicken%';

-- 6. Orders on '2015-02-15' or placed after 8 PM.
SELECT 
    order_id, date, time
FROM
    orders
WHERE
    date = '2015-02-15' OR time > '20:00:00';





/*  Phase 3: Sales Performance */
-- 1. Total quantity of pizzas sold (SUM).
SELECT 
    SUM(quantity) AS total_qty
FROM
    order_details;

-- 2. Average pizza price (AVG).
SELECT 
    ROUND(AVG(price), 2) AS avg_price
FROM
    pizzas;

-- 3. Total order value per order (JOIN, SUM, GROUP BY).
SELECT 
    o.order_id, SUM(od.quantity * p.price) AS total_order_value
FROM
    orders o
        LEFT JOIN
    order_details od ON o.order_id = od.order_id
        LEFT JOIN
    pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.order_id;

-- 4. Total quantity sold per pizza category (JOIN, GROUP BY).
SELECT 
    pt.category, SUM(od.quantity) AS total_qty
FROM
    pizza_types pt
        LEFT JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        LEFT JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category;


-- 5. Categories with more than 5,000 pizzas sold (HAVING).
SELECT 
    pt.category, SUM(od.quantity) AS total_qty
FROM
    pizza_types pt
        LEFT JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        LEFT JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
HAVING total_qty > 5000;

-- 6. Pizzas never ordered (LEFT/RIGHT JOIN).
SELECT 
    pt.name
FROM
    pizza_types pt
        LEFT JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        LEFT JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
HAVING SUM(od.quantity) IS NULL;


-- 7. Price differences between different sizes of the same pizza (SELF JOIN).	
SELECT 
    pt.pizza_type_id,
    pt.name,
    s.price AS small_price,
    m.price AS medium_price,
    l.price AS large_price,
    (m.price - s.price) AS diff_m_s,
    (l.price - m.price) AS diff_l_m,
    (l.price - s.price) AS diff_l_s
FROM
    pizza_types pt
        LEFT JOIN
    pizzas s ON s.pizza_type_id = pt.pizza_type_id
        AND s.size = 'S'
        LEFT JOIN
    pizzas m ON m.pizza_type_id = pt.pizza_type_id
        AND m.size = 'M'
        LEFT JOIN
    pizzas l ON l.pizza_type_id = pt.pizza_type_id
        AND l.size = 'L'
GROUP BY pt.pizza_type_id , pt.name , s.price , m.price , l.price;
