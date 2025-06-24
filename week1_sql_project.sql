-- 1. Creating Tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 2. Sample Data (optional)
INSERT INTO Customers VALUES 
(1, 'Alice', 'UK'),
(2, 'Bob', 'USA'),
(3, 'Charlie', 'Germany');

INSERT INTO Products VALUES 
(101, 'Laptop', 'Electronics'),
(102, 'Phone', 'Electronics'),
(103, 'Chair', 'Furniture');

INSERT INTO Orders VALUES 
(1001, 1, '2025-06-01'),
(1002, 2, '2025-06-02');

INSERT INTO OrderDetails VALUES 
(1, 1001, 101, 2, 800.00),
(2, 1001, 103, 1, 120.00),
(3, 1002, 102, 3, 500.00);

-- 3. Views

-- a. Customer Order Totals
CREATE VIEW customer_order_totals AS
SELECT 
    c.customer_id,
    c.name AS customer_name,
    SUM(od.quantity * od.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.name;

-- b. Category Sales
CREATE VIEW category_sales AS
SELECT 
    p.category,
    SUM(od.quantity * od.unit_price) AS category_revenue
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category;

-- 4. Stored Procedure

DELIMITER $$

CREATE PROCEDURE GetOrdersByCountry(IN input_country VARCHAR(50))
BEGIN
    SELECT 
        c.name AS customer_name,
        o.order_id,
        o.order_date,
        SUM(od.quantity * od.unit_price) AS order_value
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN OrderDetails od ON o.order_id = od.order_id
    WHERE c.country = input_country
    GROUP BY o.order_id;
END $$

DELIMITER ;

-- 5. Additional Queries

-- a. Top 3 Customers by Spending
SELECT 
    c.name,
    SUM(od.quantity * od.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 3;

-- b. Monthly Revenue Trend
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(od.quantity * od.unit_price) AS monthly_revenue
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;
