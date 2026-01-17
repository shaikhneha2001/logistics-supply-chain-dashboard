-- =============================================
-- LOGISTICS DOMAIN DATABASE
-- =============================================
drop database logistics_db;
-- Database Creation
CREATE DATABASE IF NOT EXISTS logistics_db;
USE logistics_db;

-- =============================================
-- TABLE CREATION
-- =============================================

-- 1. Warehouses Table
CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(100),
    location VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    capacity_sqft INT,
    manager_name VARCHAR(100),
    established_date DATE
);

-- 2. Suppliers Table
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50),
    rating DECIMAL(3,2),
    credit_terms_days INT
);

-- 3. Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    weight_kg DECIMAL(8,2),
    dimensions_cm VARCHAR(50),
    supplier_id INT,
    reorder_level INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- 4. Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_type VARCHAR(20), -- 'Retail', 'Wholesale', 'B2B'
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    registration_date DATE,
    credit_limit DECIMAL(12,2)
);

-- 5. Inventory Table
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    warehouse_id INT,
    product_id INT,
    quantity_available INT,
    quantity_reserved INT,
    last_updated TIMESTAMP,
    bin_location VARCHAR(20),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 6. Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME,
    required_date DATE,
    shipped_date DATE,
    warehouse_id INT,
    order_status VARCHAR(20), -- 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
    total_amount DECIMAL(12,2),
    shipping_cost DECIMAL(8,2),
    priority VARCHAR(10), -- 'Low', 'Medium', 'High', 'Critical'
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- 7. Order Details Table
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_percent DECIMAL(5,2),
    line_total DECIMAL(12,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 8. Shipments Table
CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    carrier_name VARCHAR(100),
    tracking_number VARCHAR(50),
    shipment_date DATETIME,
    estimated_delivery DATE,
    actual_delivery DATE,
    shipment_status VARCHAR(20), -- 'In Transit', 'Out for Delivery', 'Delivered', 'Failed'
    shipping_cost DECIMAL(8,2),
    weight_kg DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 9. Vehicles Table
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY,
    vehicle_number VARCHAR(20),
    vehicle_type VARCHAR(30), -- 'Truck', 'Van', 'Container'
    capacity_kg INT,
    fuel_type VARCHAR(20),
    warehouse_id INT,
    status VARCHAR(20), -- 'Available', 'In Use', 'Maintenance'
    purchase_date DATE,
    last_maintenance DATE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- 10. Routes Table
CREATE TABLE routes (
    route_id INT PRIMARY KEY,
    vehicle_id INT,
    driver_name VARCHAR(100),
    route_date DATE,
    start_location VARCHAR(100),
    end_location VARCHAR(100),
    distance_km DECIMAL(8,2),
    fuel_consumed_liters DECIMAL(8,2),
    total_deliveries INT,
    route_status VARCHAR(20), -- 'Planned', 'In Progress', 'Completed'
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- =============================================
-- DATA INSERTION
-- =============================================

-- Insert Warehouses (10 warehouses)
INSERT INTO warehouses VALUES
(1, 'Central Distribution Hub', '123 Main St', 'Chicago', 'Illinois', 'USA', 500000, 'John Smith', '2015-01-15'),
(2, 'West Coast Logistics Center', '456 Pacific Ave', 'Los Angeles', 'California', 'USA', 450000, 'Maria Garcia', '2016-03-20'),
(3, 'East Coast Warehouse', '789 Atlantic Blvd', 'New York', 'New York', 'USA', 400000, 'David Chen', '2014-06-10'),
(4, 'Southern Distribution Point', '321 Gulf Rd', 'Houston', 'Texas', 'USA', 350000, 'Sarah Johnson', '2017-09-05'),
(5, 'Mountain Region Hub', '654 Rocky Way', 'Denver', 'Colorado', 'USA', 300000, 'Michael Brown', '2018-02-14'),
(6, 'Pacific Northwest Center', '987 Evergreen Dr', 'Seattle', 'Washington', 'USA', 380000, 'Jennifer Lee', '2016-11-22'),
(7, 'Midwest Storage Facility', '147 Plains Ave', 'Minneapolis', 'Minnesota', 'USA', 320000, 'Robert Wilson', '2019-04-18'),
(8, 'Southwest Logistics Hub', '258 Desert Rd', 'Phoenix', 'Arizona', 'USA', 340000, 'Lisa Martinez', '2017-07-30'),
(9, 'Northeast Distribution', '369 Harbor St', 'Boston', 'Massachusetts', 'USA', 360000, 'James Anderson', '2015-12-08'),
(10, 'Southeast Warehouse', '741 Coastal Hwy', 'Atlanta', 'Georgia', 'USA', 390000, 'Patricia Taylor', '2016-05-25');

-- Insert Suppliers (50 suppliers)
INSERT INTO suppliers VALUES
(1, 'Global Tech Suppliers', 'Tom Anderson', 'tom@globaltech.com', '555-0101', 'San Francisco', 'USA', 4.5, 30),
(2, 'Premier Electronics Co', 'Emily White', 'emily@premier.com', '555-0102', 'Austin', 'USA', 4.7, 45),
(3, 'Innovative Products Inc', 'Mark Johnson', 'mark@innovative.com', '555-0103', 'Seattle', 'USA', 4.2, 30),
(4, 'Quality Goods Ltd', 'Lisa Chen', 'lisa@qualitygoods.com', '555-0104', 'Boston', 'USA', 4.8, 60),
(5, 'Metro Supplies Corp', 'David Kim', 'david@metro.com', '555-0105', 'Chicago', 'USA', 4.3, 30),
(6, 'Pacific Trading Company', 'Sarah Lee', 'sarah@pacific.com', '555-0106', 'Los Angeles', 'USA', 4.6, 45),
(7, 'Eastern Manufacturing', 'Robert Brown', 'robert@eastern.com', '555-0107', 'New York', 'USA', 4.4, 30),
(8, 'Western Distributors', 'Jennifer Davis', 'jennifer@western.com', '555-0108', 'Denver', 'USA', 4.1, 30),
(9, 'Central Wholesale Group', 'Michael Wilson', 'michael@central.com', '555-0109', 'Dallas', 'USA', 4.9, 60),
(10, 'Northern Traders Inc', 'Amanda Taylor', 'amanda@northern.com', '555-0110', 'Minneapolis', 'USA', 4.5, 45);

-- Generate more suppliers (40 more)
INSERT INTO suppliers 
SELECT 
    10 + n,
    CONCAT('Supplier ', 10 + n),
    CONCAT('Contact ', 10 + n),
    CONCAT('contact', 10 + n, '@supplier.com'),
    CONCAT('555-', LPAD(110 + n, 4, '0')),
    ELT(MOD(n, 10) + 1, 'Miami', 'Portland', 'Detroit', 'Nashville', 'Orlando', 'San Diego', 'Tampa', 'Kansas City', 'Cleveland', 'Pittsburgh'),
    'USA',
    3.5 + (RAND() * 1.5),
    CASE WHEN MOD(n, 3) = 0 THEN 60 WHEN MOD(n, 3) = 1 THEN 45 ELSE 30 END
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t2,
         (SELECT @row := 0) r
    LIMIT 40
) numbers;

-- Insert Products (1000 products)
INSERT INTO products 
SELECT 
    n,
    CONCAT(
        ELT(MOD(n, 20) + 1, 'Laptop', 'Monitor', 'Keyboard', 'Mouse', 'Printer', 'Scanner', 'Router', 'Switch', 'Cable', 'Adapter',
                            'Desk', 'Chair', 'Lamp', 'Phone', 'Tablet', 'Camera', 'Headset', 'Speaker', 'Projector', 'Drive'),
        ' Model ',
        n
    ),
    ELT(MOD(n, 8) + 1, 'Electronics', 'Furniture', 'Office Supplies', 'Computing', 'Networking', 'Accessories', 'Audio/Video', 'Storage'),
    50 + (RAND() * 950),
    1 + (RAND() * 50),
    CONCAT(FLOOR(10 + RAND() * 90), 'x', FLOOR(10 + RAND() * 90), 'x', FLOOR(5 + RAND() * 45)),
    1 + MOD(n, 50),
    50 + FLOOR(RAND() * 200)
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT @row := 0) r
    LIMIT 1000
) numbers;

-- Insert Customers (1000 customers)
INSERT INTO customers 
SELECT 
    n,
    CONCAT('Customer ', n),
    ELT(MOD(n, 3) + 1, 'Retail', 'Wholesale', 'B2B'),
    CONCAT('customer', n, '@email.com'),
    CONCAT('555-', LPAD(1000 + n, 4, '0')),
    ELT(MOD(n, 30) + 1, 'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 
                         'Dallas', 'San Jose', 'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 'San Francisco', 'Charlotte',
                         'Indianapolis', 'Seattle', 'Denver', 'Washington', 'Boston', 'Nashville', 'Detroit', 'Portland',
                         'Las Vegas', 'Memphis', 'Louisville', 'Baltimore', 'Milwaukee', 'Albuquerque'),
    ELT(MOD(n, 10) + 1, 'California', 'Texas', 'Florida', 'New York', 'Illinois', 'Pennsylvania', 'Ohio', 'Georgia', 'Michigan', 'Washington'),
    'USA',
    DATE_ADD('2018-01-01', INTERVAL FLOOR(RAND() * 2190) DAY),
    CASE WHEN MOD(n, 3) = 0 THEN 100000 WHEN MOD(n, 3) = 1 THEN 50000 ELSE 25000 END
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT @row := 0) r
    LIMIT 1000
) numbers;

-- Insert Inventory (1000 records)
INSERT INTO inventory 
SELECT 
    n,
    1 + MOD(n, 10),
    n,
    FLOOR(100 + RAND() * 900),
    FLOOR(RAND() * 50),
    TIMESTAMP(DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 320) DAY), 
              TIME(CONCAT(FLOOR(RAND() * 24), ':', FLOOR(RAND() * 60), ':00'))),
    CONCAT(CHAR(65 + MOD(n, 26)), LPAD(FLOOR(1 + RAND() * 99), 2, '0'), '-', LPAD(FLOOR(1 + RAND() * 99), 2, '0'))
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT @row := 0) r
    LIMIT 1000
) numbers;

-- Insert Orders (1500 orders)
INSERT INTO orders 
SELECT 
    n,
    1 + MOD(n, 1000),
    TIMESTAMP(DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 650) DAY), 
              TIME(CONCAT(FLOOR(8 + RAND() * 10), ':', FLOOR(RAND() * 60), ':00'))),
    DATE_ADD(DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 650) DAY), INTERVAL 3 + FLOOR(RAND() * 10) DAY),
    CASE 
        WHEN RAND() > 0.2 THEN DATE_ADD(DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 650) DAY), INTERVAL 1 + FLOOR(RAND() * 7) DAY)
        ELSE NULL 
    END,
    1 + MOD(n, 10),
    ELT(FLOOR(1 + RAND() * 5), 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'),
    500 + (RAND() * 9500),
    25 + (RAND() * 175),
    ELT(FLOOR(1 + RAND() * 4), 'Low', 'Medium', 'High', 'Critical')
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT 0 UNION SELECT 1) t4,
         (SELECT @row := 0) r
    LIMIT 1500
) numbers;

-- Insert Order Details (4000+ records - multiple items per order)
INSERT INTO order_details 
SELECT 
    n,
    1 + FLOOR((n - 1) / 3),
    1 + MOD(n * 7, 1000),
    1 + FLOOR(RAND() * 10),
    50 + (RAND() * 950),
    FLOOR(RAND() * 20),
    0
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4,
         (SELECT @row := 0) r
    LIMIT 4000
) numbers;

UPDATE order_details SET line_total = quantity * unit_price * (1 - discount_percent / 100);

-- Insert Vehicles (100 vehicles)
INSERT INTO vehicles 
SELECT 
    n,
    CONCAT('VEH-', LPAD(n, 4, '0')),
    ELT(MOD(n, 3) + 1, 'Truck', 'Van', 'Container'),
    CASE MOD(n, 3) WHEN 0 THEN 15000 WHEN 1 THEN 8000 ELSE 25000 END,
    ELT(MOD(n, 2) + 1, 'Diesel', 'Electric'),
    1 + MOD(n, 10),
    ELT(FLOOR(1 + RAND() * 3), 'Available', 'In Use', 'Maintenance'),
    DATE_ADD('2018-01-01', INTERVAL FLOOR(RAND() * 2000) DAY),
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 300) DAY)
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT @row := 0) r
    LIMIT 100
) numbers;

-- Insert Routes (1200 routes)
INSERT INTO routes 
SELECT 
    n,
    1 + MOD(n, 100),
    CONCAT('Driver ', 1 + MOD(n, 50)),
    DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 650) DAY),
    ELT(MOD(n, 10) + 1, 'Chicago', 'Los Angeles', 'New York', 'Houston', 'Denver', 'Seattle', 'Minneapolis', 'Phoenix', 'Boston', 'Atlanta'),
    ELT(MOD(n * 7, 20) + 1, 'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 
                             'Dallas', 'San Jose', 'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 'San Francisco', 'Charlotte',
                             'Indianapolis', 'Seattle', 'Denver', 'Boston'),
    50 + (RAND() * 450),
    10 + (RAND() * 90),
    1 + FLOOR(RAND() * 20),
    ELT(FLOOR(1 + RAND() * 3), 'Planned', 'In Progress', 'Completed')
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT 0 UNION SELECT 1) t4,
         (SELECT @row := 0) r
    LIMIT 1200
) numbers;

-- Insert Shipments (1200 shipments)
INSERT INTO shipments 
SELECT 
    n,
    n,
    ELT(MOD(n, 5) + 1, 'FedEx', 'UPS', 'DHL', 'USPS', 'Amazon Logistics'),
    CONCAT('TRK', LPAD(n, 10, '0')),
    TIMESTAMP(DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 650) DAY), 
              TIME(CONCAT(FLOOR(8 + RAND() * 10), ':', FLOOR(RAND() * 60), ':00'))),
    DATE_ADD(DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 650) DAY), INTERVAL 2 + FLOOR(RAND() * 5) DAY),
    CASE 
        WHEN RAND() > 0.3 THEN DATE_ADD(DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 650) DAY), INTERVAL 2 + FLOOR(RAND() * 7) DAY)
        ELSE NULL 
    END,
    ELT(FLOOR(1 + RAND() * 4), 'In Transit', 'Out for Delivery', 'Delivered', 'Failed'),
    25 + (RAND() * 175),
    10 + (RAND() * 490)
FROM (
    SELECT @row := @row + 1 AS n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT 0 UNION SELECT 1) t4,
         (SELECT @row := 0) r
    LIMIT 1200
) numbers;
show tables;
select * from customers; -- customer_id, customer_name, customer_type, email, phone, city, state, country, registration_date, credit_limit
select * from inventory; -- inventory_id, warehouse_id, product_id, quantity_available, quantity_reserved, last_updated, bin_location
select * from order_details; -- order_detail_id, order_id, product_id, quantity, unit_price, discount_percent, line_total
select * from orders; -- order_id, customer_id, order_date, required_date, shipped_date, warehouse_id, order_status, total_amount, shipping_cost, priority
select * from products; -- product_id, product_name, category, unit_price, weight_kg, dimensions_cm, supplier_id, reorder_level
select * from routes; -- route_id, vehicle_id, driver_name, route_date, start_location, end_location, distance_km, fuel_consumed_liters, total_deliveries, route_status
select * from shipments; -- shipment_id, order_id, carrier_name, tracking_number, shipment_date, estimated_delivery, actual_delivery, shipment_status, shipping_cost, weight_kg
select * from suppliers; -- supplier_id, supplier_name, contact_person, email, phone, city, country, rating, credit_terms_days
select * from vehicles; -- vehicle_id, vehicle_number, vehicle_type, capacity_kg, fuel_type, warehouse_id, status, purchase_date, last_maintenance
select * from warehouses; -- warehouse_id, warehouse_name, location, city, state, country, capacity_sqft, manager_name, established_date

-- QUESTION 1: Find customers who have placed orders with total amount above the average order amount
select c.customer_id, c.customer_name ,o.total_amount
from customers c
join orders o on c.customer_id = o.customer_id
where o.total_amount>(select avg(total_amount) from orders);

-- QUESTION 2: Rank products by their total sales revenue within each category
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(od.line_total) AS total_sales,
    RANK() OVER (PARTITION BY p.category ORDER BY SUM(od.line_total) DESC) AS sales_rank
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category;


-- QUESTION 3: Find the top 3 products by sales quantity in each warehouse
SELECT *
FROM (
    SELECT 
        o.warehouse_id,
        od.product_id,
        SUM(od.quantity) AS total_qty,
        RANK() OVER (PARTITION BY o.warehouse_id ORDER BY SUM(od.quantity) DESC) AS rnk
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.warehouse_id, od.product_id
) t
WHERE rnk <= 3;


-- QUESTION 4: Calculate running total of orders by date for each warehouse
select warehouse_id,order_date,total_amount,
sum(total_amount) over(partition by warehouse_id order by order_date
rows between UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders;

select * from orders;
select * ,sum(daily_total) over (partition by warehouse_id order by order_date) as running_total from 
(select warehouse_id , order_date,sum(total_amount) as daily_total  from orders
group by warehouse_id, order_date)s1; 

-- QUESTION 5: Calculate the difference between each order's amount and the previous order for the same customer
-- SELECT
    -- customer_id,
--     order_id,
--     total_amount,
--     LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_amount,
--     total_amount - COALESCE(LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date), 0) AS diff_amount
-- FROM orders;

select *, total_amount as diffrence from
(select *, lag(total_amount) over(partition by customer_id order by order_date) as previous_amount from orders)s1;

-- QUESTION 6: Find products that have never been ordered
SELECT *
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_details od WHERE od.product_id = p.product_id
);
select product_id from products where 
product_id not in(select product_id from order_details);


-- QUESTION 7: Calculate moving average of order amounts over the last 7 days for each warehouse
SELECT warehouse_id , AVG(total_amount) OVER (partition by  warehouse_id order by order_date
 range between  interval 6 day preceding and current row ) as 7_day_moving_avg from orders;

    

-- QUESTION 8: List all customers who have placed at least one order Concept
SELECT * from customers where
customer_id in(select customer_id from orders);


-- QUESTION 9: Show each order with the next order's date for the same customer 
SELECT
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date
FROM orders;


-- QUESTION 10: Find suppliers who supply the most expensive product in each category
SELECT s.supplier_id, s.supplier_name, p.category, p.unit_price
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE (p.category, p.unit_price) IN (
    SELECT category, MAX(unit_price)
    FROM products
    GROUP BY category
);

