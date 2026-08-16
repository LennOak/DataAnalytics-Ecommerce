--------------------
-- Finance querry
--------------------

-- Financial Analysis 01: Performance by Payment Type
-- Objective: Analyze transaction volume, average order value, and total revenue by payment method.
Select 
	payment_type,
	COUNT(order_id) AS total_transactions,
	ROUND(AVG(payment_value), 2) AS avg_order_value,
	ROUND(SUM(payment_value), 2) AS total_revenue
from olist_order_payments_dataset
group by payment_type
order by avg_order_value DESC

-- Financial Analysis 02: Credit Card Installment Behavior
-- Objective: Evaluate transaction volume, average order value, and total revenue across installment counts.
select
	payment_installments,
	count(order_id) AS total_transactions,
	ROUND(AVG(payment_value), 2) AS avg_order_value,
	ROUND(SUM(payment_value), 2) AS total_revenue
from olist_order_payments_dataset
where payment_type = 'credit_card'
	AND payment_installments IS NOT NULL 
	AND payment_installments > 0
group by payment_installments
order by payment_installments ASC

-- Financial Analysis 03: Revenue Composition and Freight Share
-- Objective: Calculate unique order count, product revenue, freight revenue, average order value, and freight percentage of total revenue.
select 
	COUNT(DISTINCT order_id) AS total_orders,
	ROUND(SUM(price), 2) AS total_product_revenue,
	ROUND(SUM(freight_value), 2) AS total_freight_revenue,
	ROUND(SUM(price + freight_value), 2) AS total_order_value,
	ROUND(AVG(price + freight_value), 2) AS avg_order_value,
	ROUND(SUM(freight_value) * 100.0 / nullif(SUM(price + freight_value), 0), 2) AS freight_pct_of_total
from olist_order_items_dataset