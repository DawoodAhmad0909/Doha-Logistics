CREATE DATABASE DLT_db;
USE DLT_db;

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

INSERT INTO suppliers(supplier_name,contact_person,email,phone,address,supplier_category,registration_date,payment_terms) VALUES 
('Qatar Building Materials', 'Ali Al-Mansoori', 'purchasing@qbm.com.qa', '+97444112233', 'Industrial Area, Street 45, Doha', 'Local', '2020-01-15', 'Net 30'),
('Gulf Electricals FZE', 'Mohammed Khan', 'sales@gulf-electricals.ae', '+97142233444', 'Jebel Ali Free Zone, Dubai', 'GCC', '2019-05-20', 'LC at Sight'), 
('Qatar Food Company', 'Fatima Ahmed', 'procurement@qfco.com.qa', '+97444556677', 'Salwa Road, Doha', 'Local', '2021-03-10', 'Net 45'), 
('Siemens Middle East', 'Hans Mueller', 'h.mueller@siemens.qa', '+97444889900', 'West Bay, Tower 2, Doha', 'International', '2018-11-05', 'Advance 50%'), 
('Al Jaber Medical Supplies', 'Khalid Al-Jaber', 'k.aljaber@jabermedical.com', '+97455667788', 'Al Sadd, Doha', 'Local', '2022-02-18', 'Net 60');

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

INSERT INTO products(product_name,description,category,unit_of_measure,unit_weight,hazardous_material,min_stock_level,lead_time_days) VALUES 
	('Portland Cement 50kg', 'Standard construction cement', 'Construction Materials', 'Bag', 50.00, FALSE, 1000, 7), 
    ('Copper Wire 2.5mm', 'Electrical wiring 100m rolls', 'Electrical', 'Roll', 5.50, FALSE, 200, 14), 
    ('Medical Oxygen Tank', '10L industrial oxygen cylinder', 'Medical Supplies', 'Unit', 15.00, TRUE, 50, 21), 
    ('Dates - Premium Grade', 'Qatari premium dates 5kg box', 'Food Products', 'Box', 5.00, FALSE, 300, 3), 
    ('HVAC Filter MERV-13', 'Commercial HVAC filters', 'HVAC', 'Piece', 1.20, FALSE, 150, 10), 
    ('Bottled Water 500ml', 'Pack of 24 bottles', 'Beverages', 'Case', 12.00, FALSE, 500, 2);

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

INSERT INTO warehouses(warehouse_name,location,capacity_sqft,temperature_controlled,manager,contact_number) VALUES 
	('Doha Central Warehouse', 'Industrial Area, Doha', 50000, FALSE, 'Omar Al-Suwaidi', '+97433112233'), 
    ('Medical Storage Facility', 'Al Wakra', 15000, TRUE, 'Dr. Aisha Mohammed', '+97433224455'), 
    ('Food Distribution Center', 'Ras Abu Aboud', 30000, TRUE, 'Khalid Al-Mohannadi', '+97433446677'), 
    ('Construction Materials Yard', 'Umm Salal', 75000, FALSE, 'Jassim Al-Hajri', '+97433558899');

CREATE TABLE inventory( 
	inventory_id INT PRIMARY KEY AUTO_INCREMENT, 
	product_id INT,
	warehouse_id INT, 
    quantity_on_hand INT, 
    quantity_allocated INT, 
    last_stock_update DATETIME
);

SELECT * FROM inventory;

INSERT INTO inventory(product_id,warehouse_id,quantity_on_hand,last_stock_update) VALUES 
	(1, 1, 2500, '2023-06-15 08:30:00'), 
    (1, 4, 1800, '2023-06-14 16:45:00'), 
    (2, 1, 350, '2023-06-15 09:15:00'), 
    (3, 2, 120, '2023-06-13 11:20:00'), 
    (4, 3, 750, '2023-06-15 10:00:00'), 
    (5, 1, 280, '2023-06-14 14:30:00'), 
    (6, 3, 1200, '2023-06-15 07:45:00');

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

INSERT INTO purchase_orders(supplier_id,order_date,status,total_amount,payment_terms,shipping_method) VALUES 
	(1, '2023-06-01', '2023-06-08', 'Delivered', 125000.00, 'Net 30', 'Local Truck'), 
    (3, '2023-06-05', '2023-06-08', 'Shipped', 87500.00, 'Net 45', 'Refrigerated Truck'), 
    (2, '2023-06-10', '2023-06-24', 'Approved', 42000.00, 'LC at Sight', 'Sea Freight'), 
    (5, '2023-06-12', '2023-07-03', 'Draft', 65000.00, 'Net 60', 'Air Freight');

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

INSERT INTO po_items(po_id,product_id,quantity,unit_price) VALUES 
	(1, 1, 2000, 25.00),
    (1, 5, 100, 85.00), 
    (2, 4, 1500, 35.00), 
    (2, 6, 500, 15.00), 
    (3, 2, 50, 420.00), 
    (4, 3, 80, 550.00);
    
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

INSERT INTO shipments(po_id,carrier_name,tracking_number,departure_date,arrival_date,shipping_cost,customs_cleared) VALUES 
	(1, 'Qatar Transport', 'QTR20230601-001', '2023-06-01', '2023-06-07', 1200.00, TRUE), 
    (2, 'Gulf Cold Chain', 'GCC20230605-045', '2023-06-05', NULL, 850.00, FALSE), 
    (3, 'Maersk Line', 'MAE123456789', '2023-06-15', NULL, 4200.00, FALSE);

CREATE TABLE customers( 
	customer_id INT PRIMARY KEY AUTO_INCREMENT, 
    customer_name TEXT, 
    contact_person TEXT,
    email TEXT, phone VARCHAR(15), 
    address TEXT, 
    customer_type VARCHAR(25) 
);

SELECT * FROM customers;

INSERT INTO customers(customer_name,contact_person,email,phone,address,customer_type) VALUES 
	('Qatar Construction Co.', 'Abdullah Al-Kuwari', 'procurement@qatarconstruction.com', '+97444332211', 'West Bay, Doha', 'Wholesale'), 
    ('Hamad Medical Corporation', 'Dr. Fatima Al-Sada', 'supplychain@hmc.org.qa', '+97444887766', 'Al Rayyan Road, Doha', 'Government'), 
    ('Al Sultan Restaurant Group', 'Hassan Sultan', 'hsultan@alsultan.com', '+97455664433', 'The Pearl, Doha', 'Hospitality'), 
    ('Doha Electronics', 'Rajiv Patel', 'purchasing@dohaelectronics.qa', '+97444221133', 'Salwa Road, Doha', 'Retail'), 
    ('Qatar Ministry of Education', 'Mohammed Al-Emadi', 'moeprocurement@edu.gov.qa', '+97444998877', 'Al Dafna, Doha', 'Government');

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

INSERT INTO sales_orders(customer_id,order_date,required_date,status,total_amount,payment_method) VALUES 
	(2, '2023-06-05', '2023-06-07', 'Delivered', 42000.00, 'Bank Transfer'), 
    (1, '2023-06-08', '2023-06-12', 'Processing', 187500.00, 'Letter of Credit'), 
    (3, '2023-06-10', '2023-06-15', 'New', 6250.00, 'Credit Card'), 
    (4, '2023-06-12', '2023-06-14', 'Shipped', 8400.00, 'Bank Transfer');

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

INSERT INTO so_items(so_id,product_id,quantity,unit_price) VALUES 
	(1, 3, 60, 700.00), 
    (2, 1, 5000, 30.00), 
    (2, 5, 125, 90.00), 
    (3, 4, 25, 250.00), 
    (4, 2, 20, 420.00);

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

INSERT INTO transportation(vehicle_type,registration_number,capacity_kg,driver_name,driver_contact,last_maintenance_date,status) VALUES 
	('Flatbed Truck', 'Q 12345', 20000.00, 'Mohammed Ali', '+97433114455', '2023-05-20', 'Available'), 
    ('Refrigerated Van', 'Q 67890', 5000.00, 'Ahmed Hassan', '+97433225566', '2023-06-01', 'In Transit'), 
    ('Box Truck', 'Q 54321', 10000.00, 'Omar Mahmoud', '+97433336677', '2023-04-15', 'Maintenance');

-- KEY Queries

-- 1. List all local Qatari suppliers with their total purchase order values in the last 6 months, sorted by highest spend.
SELECT 
	s.supplier_name, SUM(po.total_amount) AS total_spent 
FROM suppliers s 
JOIN purchase_orders po ON s.supplier_id = po.supplier_id 
WHERE 
	s.supplier_category = 'Local' AND po.order_date >= CURDATE() - INTERVAL 6 MONTH 
GROUP BY s.supplier_name ORDER BY total_spent DESC;

-- 2. Identify suppliers with delayed shipments (actual delivery date > expected delivery date) and calculate average delay days. 
SELECT s.supplier_name, AVG(DATEDIFF(sh.arrival_date, po.expected_delivery_date)) AS avg_delay_days 
FROM shipments sh 
JOIN purchase_orders po ON sh.po_id = po.po_id 
JOIN suppliers s ON po.supplier_id = s.supplier_id 
WHERE sh.arrival_date IS NOT NULL AND sh.arrival_date > po.expected_delivery_date 
GROUP BY s.supplier_name;

-- 3. Compare procurement costs between local, GCC, and international suppliers by product category. 
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
    
-- 4. Show products currently below minimum stock levels across all warehouses. 
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

-- 5. Calculate warehouse capacity utilization (used vs. available space) by location. 
SELECT 
	w.location, w.capacity_sqft, SUM(i.quantity_on_hand) AS used_space, 
	ROUND((SUM(i.quantity_on_hand)/w.capacity_sqft)*100, 2) AS utilization_percent 
FROM warehouses w 
LEFT JOIN inventory i ON w.warehouse_id = i.warehouse_id 
GROUP BY w.warehouse_id;

-- 6. Identify slow-moving inventory (products with no sales in last 90 days but stock > 50 units). 
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
    
-- 7. List top 5 customers by total spend, including their preferred payment methods. 
SELECT c.customer_name, so.payment_method, SUM(so.total_amount) AS total_spent 
FROM customers c 
JOIN sales_orders so ON c.customer_id = so.customer_id 
GROUP BY c.customer_id ,so.payment_method
ORDER BY total_spent DESC 
LIMIT 5;

-- 8. Analyze sales trends for construction materials before/during/after major projects (e.g., World Cup 2022). 
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

-- 10. Compare on-time delivery rates between different shipping methods. 
SELECT 
	po.shipping_method, COUNT(*) AS total_orders, 
	SUM(CASE WHEN sh.arrival_date <= po.expected_delivery_date THEN 1 ELSE 0 END) AS on_time,
    ROUND(SUM(CASE WHEN sh.arrival_date <= po.expected_delivery_date THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2) AS on_time_rate 
FROM purchase_orders po 
JOIN shipments sh ON po.po_id = sh.po_id 
WHERE sh.arrival_date IS NOT NULL 
GROUP BY po.shipping_method;

-- 11. Calculate average shipping costs as % of order value by supplier origin. 
SELECT s.supplier_category, ROUND(AVG(sh.shipping_cost / po.total_amount * 100), 2) AS avg_shipping_percent 
FROM shipments sh 
JOIN purchase_orders po ON sh.po_id = po.po_id 
JOIN suppliers s ON po.supplier_id = s.supplier_id 
WHERE po.total_amount > 0 
GROUP BY s.supplier_category;

-- 13. Calculate inventory turnover ratio by product category (COGS / average inventory).
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

-- 14. Show monthly purchase order values vs. sales order values to identify cash flow gaps. 
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

-- 15. Rank products by profitability (sales price vs. procurement cost) for the last quarter. 
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

-- 16. Predict stockouts using lead times and current demand patterns.
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
    
-- 17. Optimize warehouse layouts based on product movement frequency and weight. 
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
    
-- 18. Analyze customs clearance bottlenecks for international shipments. 
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
    suppliers s ON po.supplier_id = s.supplier_id
WHERE 
    s.supplier_category = 'International'
    AND sh.arrival_date IS NOT NULL
ORDER BY 
    clearance_status DESC, days_since_arrival DESC;