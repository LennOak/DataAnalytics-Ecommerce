--------------------
-- Finance Query
--------------------

-- Financial Analysis 01: Performance by Payment Type
-- Objective: Analyze transaction volume, average order value, and total revenue by payment method.
WITH tb_payment_summary AS (
SELECT  
	payment_type,
	COUNT(order_id) AS total_transactions,
	ROUND(AVG(payment_value), 2) AS avg_order_value,
	ROUND(SUM(payment_value), 2) AS total_revenue,
	DENSE_RANK() OVER (ORDER BY SUM(payment_value) DESC) AS rank_revenue
FROM olist_order_payments_dataset
GROUP BY payment_type
)
SELECT *
FROM tb_payment_summary
ORDER BY avg_order_value DESC;

-- Financial Analysis 02: Credit Card Installment Behavior
-- Objective: Evaluate transaction volume, average order value, and total revenue across installment counts.
SELECT
	payment_installments,
	COUNT(order_id) AS total_transactions,
	ROUND(AVG(payment_value), 2) AS avg_order_value,
	ROUND(SUM(payment_value), 2) AS total_revenue
FROM olist_order_payments_dataset
WHERE payment_type = 'credit_card'
	AND payment_installments IS NOT NULL 
	AND payment_installments > 0
GROUP BY payment_installments
ORDER BY payment_installments ASC;

-- Financial Analysis 03: Revenue Composition and Freight Share
-- Objective: Calculate unique order count, product revenue, freight revenue, average order value, and freight percentage of total revenue.
SELECT
	COUNT(DISTINCT order_id) AS total_orders,
	ROUND(SUM(price), 2) AS total_product_revenue,
	ROUND(SUM(freight_value), 2) AS total_freight_revenue,
	ROUND(SUM(price + freight_value), 2) AS total_order_value,
	ROUND(AVG(price + freight_value), 2) AS avg_order_value,
	ROUND(SUM(freight_value) * 100.0 / NULLIF(SUM(price + freight_value), 0), 2) AS freight_pct_of_total
FROM olist_order_items_dataset;
