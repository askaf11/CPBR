USE CPBR;

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG = 'CPBR';

-- Task 1
SELECT customers.*, orders.order_id, orders.order_status FROM customers INNER JOIN orders ON customers.customer_id= orders.customer_id;

-- Task 2 
-- PRINT STORE ID & TOTAL SALES
SELECT orders.store_id, SUM(order_items.quantity*order_items.list_price) as total_sales FROM order_items
JOIN orders ON order_items.order_id = orders.order_id
GROUP BY orders.store_id ORDER BY total_sales DESC;

-- PRINT STORE NAME & TOTAL SALES
SELECT stores.store_name, SUM(order_items.quantity*order_items.list_price) as total_sales FROM order_items
JOIN orders ON order_items.order_id = orders.order_id
JOIN stores ON orders.store_id = stores.store_id
GROUP BY store_name;

-- Task 3
SELECT product_id, product_name FROM products WHERE product_id NOT IN 
(SELECT DISTINCT product_id FROM order_items) ORDER BY product_id ASC;

-- Task 4 
SELECT s.first_name + ' ' + s.last_name AS StaffName, s.email, m.first_name + ' ' + m.last_name AS ManagerName 
FROM staffs s LEFT JOIN staffs m ON s.manager_id = m.staff_id;

--Task 5
SELECT orders.store_id, SUM(order_items.quantity * order_items.list_price) AS total_sales,
RANK() OVER (ORDER BY SUM(order_items.quantity * order_items.list_price) DESC) AS store_Rank
FROM order_items JOIN orders ON order_items.order_id = orders.order_id GROUP BY orders.store_id;

-- Task 6
SELECT order_id, order_date, shipped_date, DATEDIFF(DAY, order_date, shipped_date) AS days_to_ship FROM orders;

-- Task 7
SELECT 
    order_id,
    order_status,
    CASE 
        WHEN order_status = '1' THEN 'pending'
        WHEN order_status = '2' THEN 'processing'
        WHEN order_status = '3' THEN 'rejected'
        WHEN order_status = '4' THEN 'completed'
    END AS status_category
FROM 
    orders;

-- Task 8
SELECT orders.order_id, products.product_name, stores.store_name FROM orders
JOIN stores ON orders.store_id = stores.store_id
JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON order_items.product_id = products.product_id

-- Task 9
CREATE TABLE #TempJoin(
	order_id INT,
	total_by_order INT
);

INSERT INTO #TempJoin(order_id, total_by_order)
SELECT order_items.order_id, SUM(order_items.quantity*order_items.list_price) as total_sales FROM order_items GROUP BY order_items.order_id

SELECT * FROM #TempJoin ORDER BY order_id ASC;

DROP TABLE #TempJoin


