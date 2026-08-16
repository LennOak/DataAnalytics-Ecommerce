USE e_commerce;
GO

-- ====================================================================
-- 1. FACT TABLES
-- ====================================================================

-- Creating the Sales Fact View
CREATE VIEW vw_fact_sales AS
SELECT
	items.order_id AS order_id,
	items.order_item_id AS items_key,
	cust.customer_unique_id AS customer_key,
	items.product_id AS product_key,
	items.seller_id AS seller_key,
	orders.order_status AS order_status,
	orders.order_purchase_timestamp AS purchase_at,
	orders.delay_days AS delay_days,
	orders.is_delayed AS is_delayed,
	orders.seller_dispatch_days AS seller_dispatch_days,
	items.price AS item_price,
	items.freight_value AS freight_value
FROM olist_order_items_dataset items
INNER JOIN olist_orders_dataset orders
	ON items.order_id = orders.order_id
INNER JOIN olist_customers_dataset cust 
	ON orders.customer_id = cust.customer_id;
GO

-- Creating the Payments Fact View
CREATE VIEW vw_fact_payments AS
SELECT
	order_id AS order_id,
	payment_sequential AS payment_sequence,
	payment_type AS payment_type,
	payment_installments AS installments_count,
	payment_value AS payment_amount
FROM olist_order_payments_dataset;
GO

-- Creating the Customer Reviews Fact View
CREATE VIEW vw_fact_review AS
SELECT
	review_id AS review_id,
	order_id AS order_id,
	review_score AS review_score,
	review_comment_title AS comment_title,
	review_comment_message AS comment_message,
	review_creation_date AS review_created_at,
	review_answer_timestamp AS review_answered_at
FROM olist_order_reviews_dataset;
GO


-- ====================================================================
-- 2. DIMENSION TABLES
-- ====================================================================

-- Creating the Customer Dimension View
CREATE VIEW vw_dim_customer AS
SELECT
	customer_unique_id AS customer_key,
	customer_zip_code_prefix AS customer_zip_code,
	UPPER(customer_city) AS customer_city,
	UPPER(customer_state) AS customer_state
FROM olist_customers_dataset;
GO

-- Creating the Products Dimension View
CREATE VIEW vw_dim_products AS
SELECT
	product_id AS product_key,
	product_category_name AS product_category,
	product_name_lenght AS product_name_length,
	product_description_lenght AS product_description_length,
	product_photos_qty AS product_photos_quantity,
	product_weight_g AS product_weight_grams,
	product_length_cm AS product_length_cm,
	product_height_cm AS product_height_cm,
	product_width_cm AS product_width_cm
FROM olist_products_dataset;
GO

-- Creating the Sellers Dimension View
CREATE VIEW vw_dim_sellers AS
SELECT
	seller_id AS seller_key,
	seller_zip_code_prefix AS seller_zip_code,
	UPPER(seller_city) AS seller_city,
	UPPER(seller_state) AS seller_state
FROM olist_sellers_dataset;
GO

-- Creating the Geolocation Dimension View
CREATE VIEW vw_dim_geolocation AS
SELECT
	geolocation_zip_code_prefix AS zip_code_key,
	AVG(geolocation_lat) AS latitude,
	AVG(geolocation_lng) AS longitude,
	UPPER(MAX(geolocation_city)) AS city,  -- Standardized aggregation for SQL Server compatibility
	UPPER(MAX(geolocation_state)) AS state  -- Standardized aggregation for SQL Server compatibility
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix;
GO