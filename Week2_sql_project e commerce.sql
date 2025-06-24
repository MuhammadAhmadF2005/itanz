--Top 10 Customers by Revenue
CREATE OR REPLACE VIEW top_customers AS
SELECT 
  CustomerID,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_spent,
  COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail
WHERE Quantity > 0 AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;

--Daily Sales Summary
CREATE OR REPLACE VIEW daily_sales AS
SELECT 
  DATE(STR_TO_DATE(InvoiceDate, '%m/%e/%Y %H:%i')) AS sales_date,
  COUNT(DISTINCT InvoiceNo) AS total_orders,
  SUM(Quantity) AS total_items_sold,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY sales_date
ORDER BY sales_date;

--Daily Sales by Country
CREATE OR REPLACE VIEW daily_sales_by_country AS
SELECT 
  DATE(STR_TO_DATE(InvoiceDate, '%m/%e/%Y %H:%i')) AS sales_date,
  Country,
  COUNT(DISTINCT InvoiceNo) AS total_orders,
  SUM(Quantity) AS total_items_sold,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY sales_date, Country
ORDER BY sales_date, total_revenue DESC;

--Top 10 Products by Total Revenue
CREATE OR REPLACE VIEW top_products_by_revenue AS
SELECT 
  Description AS product_name,
  SUM(Quantity) AS total_quantity_sold,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail
WHERE Quantity > 0 AND Description IS NOT NULL
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;
