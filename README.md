# Doha Logistics
## Overview 
This database models a comprehensive supply chain and inventory system for a Qatari organization, covering end-to-end logistics — from procurement to order fulfillment. It includes detailed information on:

 •Suppliers categorized by region (Local, GCC, International)

 •Products with attributes like unit weight, category, hazardous status, and stock thresholds

 •Warehouses with capacity and environmental control details

 •Inventory levels across warehouses

 •Purchase Orders (POs) and corresponding shipments from suppliers

 •Sales Orders (SOs) to customers and related order items

 •Transportation resources with driver info and vehicle status


Additionally, the database supports advanced analytical queries for inventory health, sales trends, supplier reliability, and warehouse efficiency.
## Objectives 
To design and implement a comprehensive Qatar Supply Chain Management System that optimizes procurement, inventory, logistics, and distribution operations through data-driven insights, ensuring cost efficiency, timely deliveries, and compliance with Qatar's economic and regulatory requirements.
## Database Creation 
``` sql
CREATE DATABASE DLT_db;
USE DLT_db;
```
## Table Creation
### Table:
``` sql 
CREATE TABLE suppliers( 
        supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name TEXT, 
    contact_person TEXT,
    email TEXT,
    phone VARCHAR(15),
    address TEXT,
    city VARCHAR(25),
    country VARCHAR(25),
    supplier_category VARCHAR(25),
    registration_date DATE,
    payment_terms VARCHAR(25)
);

SELECT * FROM suppliers;
```
### Table:products
``` sql
CREATE TABLE products( 
        product_id INT PRIMARY KEY AUTO_INCREMENT, 
    product_name TEXT, description TEXT, 
    category TEXT, 
    unit_of_measure VARCHAR(25), 
    unit_weight DECIMAL(8,2), 
    hazardous_material BOOLEAN, 
    min_stock_level INT, 
    lead_time_days INT
);

SELECT * FROM products;
```
### Table:warehouses
``` sql
CREATE TABLE warehouses( 
        warehouse_id INT PRIMARY KEY AUTO_INCREMENT, 
    warehouse_name TEXT, 
    location TEXT, 
    capacity_sqft INT, 
    temperature_controlled BOOLEAN, 
    manager TEXT, 
    contact_number VARCHAR(15) 
);

SELECT * FROM warehouses;
```
### Table:inventory
``` sql
CREATE TABLE inventory( 
        inventory_id INT PRIMARY KEY AUTO_INCREMENT, 
        product_id INT,
        warehouse_id INT, 
    quantity_on_hand INT, 
    quantity_allocated INT, 
    last_stock_update DATETIME
);

SELECT * FROM inventory;
```
### Table:purchase_orders
``` sql
CREATE TABLE purchase_orders( 
        po_id INT PRIMARY KEY AUTO_INCREMENT, 
    supplier_id INT, 
    order_date DATE, 
    expected_delivery_date DATE, 
    status VARCHAR(25), 
    total_amount DECIMAL(15,2), 
    payment_terms VARCHAR(25), 
    shipping_method VARCHAR(50)
);

SELECT * FROM purchase_orders;
```
### Table:po_items
``` sql
CREATE TABLE po_items( 
        po_item_id INT PRIMARY KEY AUTO_INCREMENT, 
    po_id INT, 
    product_id INT, 
    quantity INT, 
    unit_price DECIMAL(10,2), 
    line_total DECIMAL(15,2), 
    received_quantity INT
);

SELECT * FROM po_items;
```
### Table:shipments
``` sql
CREATE TABLE shipments( 
        shipment_id INT PRIMARY KEY AUTO_INCREMENT, 
    po_id INT, 
    carrier_name TEXT, 
    tracking_number TEXT, 
    departure_date DATE, 
    arrival_date DATE, 
    shipping_cost DECIMAL(10,2),
    customs_cleared BOOLEAN 
);

SELECT * FROM shipments;
```
### Table:customers
``` sql
CREATE TABLE customers( 
        customer_id INT PRIMARY KEY AUTO_INCREMENT, 
    customer_name TEXT, 
    contact_person TEXT,
    email TEXT, phone VARCHAR(15), 
    address TEXT, 
    customer_type VARCHAR(25) 
);

SELECT * FROM customers;
```
### Table:sales_orders
``` sql
CREATE TABLE sales_orders( 
        so_id INT PRIMARY KEY AUTO_INCREMENT, 
    customer_id INT, 
    order_date DATE, 
    required_date DATE, 
    status VARCHAR(25), 
    total_amount DECIMAL(15,2), 
    payment_method VARCHAR(25)
);

SELECT * FROM sales_orders;
```
### Table:so_items
``` sql
CREATE TABLE so_items( 
        so_item_id INT PRIMARY KEY AUTO_INCREMENT, 
    so_id INT, 
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2), 
    line_total DECIMAL(15,2),
    allocated_quantity INT
);

SELECT * FROM so_items;
```
### Table:transportation
``` sql
CREATE TABLE transportation( 
        transport_id INT PRIMARY KEY AUTO_INCREMENT, 
    vehicle_type TEXT, 
    registration_number TEXT, 
    capacity_kg DECIMAL(10,2), 
    driver_name VARCHAR(50), 
    driver_contact VARCHAR(15), 
    last_maintenance_date DATE, 
    status VARCHAR(25) 
);

SELECT * FROM transportation;
```
## KEY Queries

#### 1. List all local Qatari suppliers with their total purchase order values in the last 6 months, sorted by highest spend.
``` sql
SELECT 
        s.supplier_name, SUM(po.total_amount) AS total_spent 
FROM suppliers s 
JOIN purchase_orders po ON s.supplier_id = po.supplier_id 
WHERE 
        s.supplier_category = 'Local' AND po.order_date >= CURDATE() - INTERVAL 6 MONTH 
GROUP BY s.supplier_name ORDER BY total_spent DESC;
```
#### 2. Identify suppliers with delayed shipments (actual delivery date > expected delivery date) and calculate average delay days. 
``` sql
SELECT s.supplier_name, AVG(DATEDIFF(sh.arrival_date, po.expected_delivery_date)) AS avg_delay_days 
FROM shipments sh 
JOIN purchase_orders po ON sh.po_id = po.po_id 
JOIN suppliers s ON po.supplier_id = s.supplier_id 
WHERE sh.arrival_date IS NOT NULL AND sh.arrival_date > po.expected_delivery_date 
GROUP BY s.supplier_name;
```
#### 3. Compare procurement costs between local, GCC, and international suppliers by product category. 
``` sql
SELECT 
    s.supplier_category,
    p.category AS product_category,
    ROUND(SUM(pi.quantity * pi.unit_price), 2) AS total_procurement_cost,
    ROUND(SUM(pi.quantity * pi.unit_price) / NULLIF(SUM(pi.quantity), 0), 2) AS avg_unit_cost
FROM 
    po_items pi
JOIN 
    purchase_orders po ON pi.po_id = po.po_id
JOIN 
    suppliers s ON po.supplier_id = s.supplier_id
JOIN 
    products p ON pi.product_id = p.product_id
GROUP BY 
    s.supplier_category, p.category
ORDER BY 
    s.supplier_category, total_procurement_cost DESC;
```
#### 4. Show products currently below minimum stock levels across all warehouses. 
``` sql
SELECT 
    p.product_name,
    p.category,
    p.min_stock_level,
    SUM(i.quantity_on_hand) AS total_on_hand,
    (p.min_stock_level - SUM(i.quantity_on_hand)) AS shortfall
FROM 
    products p
JOIN 
    inventory i ON p.product_id = i.product_id
GROUP BY 
    p.product_id, p.product_name, p.category, p.min_stock_level
HAVING 
    total_on_hand < p.min_stock_level
ORDER BY 
    shortfall DESC;
```
#### 5. Calculate warehouse capacity utilization (used vs. available space) by location. 
``` sql
SELECT 
        w.location, w.capacity_sqft, SUM(i.quantity_on_hand) AS used_space, 
        ROUND((SUM(i.quantity_on_hand)/w.capacity_sqft)*100, 2) AS utilization_percent 
FROM warehouses w 
LEFT JOIN inventory i ON w.warehouse_id = i.warehouse_id 
GROUP BY w.warehouse_id;
```
#### 6. Identify slow-moving inventory (products with no sales in last 90 days but stock > 50 units). 
``` sql
WITH recent_sales AS (
    SELECT DISTINCT si.product_id
    FROM so_items si
    JOIN sales_orders so ON si.so_id = so.so_id
    WHERE so.order_date >= CURDATE() - INTERVAL 90 DAY
),
stock_summary AS (
    SELECT 
        i.product_id,
        SUM(i.quantity_on_hand) AS total_quantity
    FROM inventory i
    GROUP BY i.product_id
)
SELECT 
    ss.product_id,
    p.product_name,
    p.category,
    ss.total_quantity
FROM 
    stock_summary ss
JOIN products p ON ss.product_id = p.product_id
LEFT JOIN recent_sales rs ON ss.product_id = rs.product_id
WHERE 
    rs.product_id IS NULL      
    AND ss.total_quantity > 50
ORDER BY 
    ss.total_quantity DESC;
```
#### 7. List top 5 customers by total spend, including their preferred payment methods. 
``` sql
SELECT c.customer_name, so.payment_method, SUM(so.total_amount) AS total_spent 
FROM customers c 
JOIN sales_orders so ON c.customer_id = so.customer_id 
GROUP BY c.customer_id ,so.payment_method
ORDER BY total_spent DESC 
LIMIT 5;
```
#### 8. Analyze sales trends for construction materials before/during/after major projects (e.g., World Cup 2022). 
``` sql
SELECT 
        CASE WHEN so.order_date < '2022-01-01' THEN 'Before WC' 
    WHEN so.order_date BETWEEN '2022-11-01' AND '2022-12-31' THEN 'During WC' 
    ELSE 'After WC' END AS phase,
    SUM(soi.unit_price*soi.quantity) AS sales_total 
FROM so_items soi 
JOIN sales_orders so ON soi.so_id = so.so_id 
JOIN products p ON soi.product_id = p.product_id 
WHERE p.category = 'Construction Materials' 
GROUP BY phase;
```
#### 10. Compare on-time delivery rates between different shipping methods. 
``` sql
SELECT 
        po.shipping_method, COUNT(*) AS total_orders, 
        SUM(CASE WHEN sh.arrival_date <= po.expected_delivery_date THEN 1 ELSE 0 END) AS on_time,
    ROUND(SUM(CASE WHEN sh.arrival_date <= po.expected_delivery_date THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2) AS on_time_rate 
FROM purchase_orders po 
JOIN shipments sh ON po.po_id = sh.po_id 
WHERE sh.arrival_date IS NOT NULL 
GROUP BY po.shipping_method;
```
#### 11. Calculate average shipping costs as % of order value by supplier origin. 
``` sql
SELECT s.supplier_category, ROUND(AVG(sh.shipping_cost / po.total_amount * 100), 2) AS avg_shipping_percent 
FROM shipments sh 
JOIN purchase_orders po ON sh.po_id = po.po_id 
JOIN suppliers s ON po.supplier_id = s.supplier_id 
WHERE po.total_amount > 0 
GROUP BY s.supplier_category;
```
#### 13. Calculate inventory turnover ratio by product category (COGS / average inventory).
``` sql
WITH avg_costs AS (
    SELECT 
        pi.product_id,
        SUM(pi.quantity * pi.unit_price) / NULLIF(SUM(pi.quantity), 0) AS avg_procurement_cost
    FROM 
        po_items pi
    GROUP BY pi.product_id
),
cogs_by_category AS (
    SELECT 
        p.category,
        SUM(si.quantity * ac.avg_procurement_cost) AS estimated_cogs
    FROM 
        so_items si
    JOIN products p ON si.product_id = p.product_id
    JOIN avg_costs ac ON si.product_id = ac.product_id
    GROUP BY p.category
),
inventory_value_by_category AS (
    SELECT 
        p.category,
        AVG(i.quantity_on_hand * ac.avg_procurement_cost) AS avg_inventory_value
    FROM 
        inventory i
    JOIN products p ON i.product_id = p.product_id
    JOIN avg_costs ac ON i.product_id = ac.product_id
    GROUP BY p.category
)
SELECT 
    c.category,
    ROUND(c.estimated_cogs, 2) AS estimated_cogs,
    ROUND(iv.avg_inventory_value, 2) AS average_inventory_value,
    ROUND(c.estimated_cogs / NULLIF(iv.avg_inventory_value, 0), 2) AS inventory_turnover_ratio
FROM 
    cogs_by_category c
JOIN 
    inventory_value_by_category iv ON c.category = iv.category
ORDER BY inventory_turnover_ratio DESC;
```
#### 14. Show monthly purchase order values vs. sales order values to identify cash flow gaps. 
``` sql
SELECT 
    month,
    SUM(total_purchase_orders) AS total_purchase_orders,
    SUM(total_sales_orders) AS total_sales_orders,
    SUM(total_sales_orders) - SUM(total_purchase_orders) AS net_cash_flow
FROM (

    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS total_purchase_orders,
        0 AS total_sales_orders
    FROM purchase_orders
    GROUP BY month

    UNION ALL

    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        0 AS total_purchase_orders,
        SUM(total_amount) AS total_sales_orders
    FROM sales_orders
    GROUP BY month
) AS combined
GROUP BY month
ORDER BY month;
```
#### 15. Rank products by profitability (sales price vs. procurement cost) for the last quarter. 
``` sql
WITH recent_sales AS (
    SELECT 
        si.product_id,
        SUM(si.quantity) AS total_qty_sold,
        SUM(si.quantity * si.unit_price) AS total_sales_revenue
    FROM 
        so_items si
    JOIN sales_orders so ON si.so_id = so.so_id
    WHERE so.order_date >= CURDATE() - INTERVAL 3 MONTH
    GROUP BY si.product_id
),
avg_procurement_cost AS (
    SELECT 
        pi.product_id,
        SUM(pi.quantity * pi.unit_price) / NULLIF(SUM(pi.quantity), 0) AS avg_unit_cost
    FROM 
        po_items pi
    GROUP BY pi.product_id
)
SELECT
    p.product_name,
    p.category,
    rs.total_qty_sold,
    rs.total_sales_revenue,
    ROUND(ac.avg_unit_cost, 2) AS avg_procurement_cost_per_unit,
    ROUND(ac.avg_unit_cost * rs.total_qty_sold, 2) AS estimated_total_procurement_cost,
    ROUND(rs.total_sales_revenue - (ac.avg_unit_cost * rs.total_qty_sold), 2) AS profit,
    ROUND(
        (rs.total_sales_revenue - (ac.avg_unit_cost * rs.total_qty_sold)) 
        / NULLIF(rs.total_sales_revenue, 0) * 100, 2
    ) AS profit_margin_percent
FROM 
    recent_sales rs
JOIN avg_procurement_cost ac ON rs.product_id = ac.product_id
JOIN products p ON rs.product_id = p.product_id
ORDER BY profit DESC
LIMIT 10;
```
#### 16. Predict stockouts using lead times and current demand patterns.
``` sql
WITH daily_demand AS (
    SELECT 
        si.product_id,
        SUM(si.quantity) / 30 AS avg_daily_demand
    FROM 
        so_items si
    JOIN sales_orders so ON si.so_id = so.so_id
    WHERE so.order_date >= CURDATE() - INTERVAL 30 DAY
    GROUP BY si.product_id
),
stock_levels AS (
    SELECT 
        product_id,
        SUM(quantity_on_hand) AS total_on_hand
    FROM 
        inventory
    GROUP BY product_id
),
projected_demand AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        p.lead_time_days,
        dd.avg_daily_demand,
        sl.total_on_hand,
        ROUND(dd.avg_daily_demand * p.lead_time_days, 2) AS projected_demand_during_lead_time,
        CASE 
            WHEN sl.total_on_hand < dd.avg_daily_demand * p.lead_time_days THEN 'YES'
            ELSE 'NO'
        END AS likely_stockout
    FROM 
        products p
    JOIN daily_demand dd ON p.product_id = dd.product_id
    JOIN stock_levels sl ON p.product_id = sl.product_id
)
SELECT 
    product_name,
    category,
    total_on_hand,
    avg_daily_demand,
    lead_time_days,
    projected_demand_during_lead_time,
    likely_stockout
FROM 
    projected_demand
WHERE 
    likely_stockout = 'YES'
ORDER BY 
    projected_demand_during_lead_time DESC;
```
#### 17. Optimize warehouse layouts based on product movement frequency and weight.
``` sql 
WITH movement_stats AS (
    SELECT 
        si.product_id,
        SUM(si.quantity) AS total_sales_last_90_days
    FROM 
        so_items si
    JOIN sales_orders so ON si.so_id = so.so_id
    WHERE so.order_date >= CURDATE() - INTERVAL 90 DAY
    GROUP BY si.product_id
),
product_analysis AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        p.unit_weight,
        COALESCE(ms.total_sales_last_90_days, 0) AS movement_qty
    FROM 
        products p
    LEFT JOIN movement_stats ms ON p.product_id = ms.product_id
)
SELECT 
    product_id,
    product_name,
    category,
    unit_weight,
    movement_qty,
    CASE 
        WHEN movement_qty >= 500 AND unit_weight <= 10 THEN 'Place near exit (Fast-moving, light)'
        WHEN movement_qty >= 500 AND unit_weight > 10 THEN 'Medium zone (Fast-moving, heavy)'
        WHEN movement_qty < 500 AND unit_weight <= 10 THEN 'Back shelves (Slow-moving, light)'
        ELSE 'Far back or high racks (Slow-moving, heavy)'
    END AS recommended_storage_zone
FROM 
    product_analysis
ORDER BY 
    movement_qty DESC, unit_weight ASC;
```
#### 18. Analyze customs clearance bottlenecks for international shipments. 
``` sql
SELECT 
    sh.shipment_id,
    s.supplier_name,
    po.po_id,
    sh.carrier_name,
    sh.tracking_number,
    sh.departure_date,
    sh.arrival_date,
    DATEDIFF(CURDATE(), sh.arrival_date) AS days_since_arrival,
    sh.customs_cleared,
    CASE 
        WHEN sh.customs_cleared = FALSE AND DATEDIFF(CURDATE(), sh.arrival_date) > 5 THEN ' Customs Bottleneck'
        WHEN sh.customs_cleared = FALSE THEN 'Pending'
        ELSE 'Cleared'
    END AS clearance_status
FROM 
    shipments sh
JOIN 
    purchase_orders po ON sh.po_id = po.po_id
JOIN 
    suppliers s ON po.supplier_id
```
# Conclusion
This supply chain database empowers operational efficiency, data-driven procurement, and inventory control by combining transactional depth with analytical flexibility. It provides visibility into logistics bottlenecks, cost drivers, and customer demand patterns — enabling smarter decisions across the entire fulfillment lifecycle.
