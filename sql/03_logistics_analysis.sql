--------------------
-- Logistics Query
--------------------

-- Logistics Analysis 01: Lead Time and Delay Rate by Customer State
-- Objective: Analyze total delivery lead time, carrier dispatch time, transit time, and delay rate percentage across customer states.
SELECT 
    c.customer_state,
    COUNT(o.order_id) AS total_orders_delivered,
    ROUND(AVG(ROUND(DATEDIFF(day, o.order_purchase_timestamp, o.order_delivered_customer_date), 2)), 2) AS avg_lead_time_days,
    ROUND(AVG(ROUND(DATEDIFF(day, o.order_purchase_timestamp, o.order_delivered_carrier_date), 2)), 2) AS avg_dispatch_time_days,
    ROUND(AVG(ROUND(DATEDIFF(day, o.order_delivered_carrier_date, o.order_delivered_customer_date), 2)), 2) AS avg_shipping_time_days,
    SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS total_delayed_orders,
    ROUND(
        (SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1.0 ELSE 0.0 END) / 
        NULLIF(COUNT(o.order_id), 0)) * 100, 2
    ) AS delay_rate_percentage
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c 
	ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_lead_time_days DESC;


-- Logistics Analysis 02: Estimated Delivery Date Accuracy
-- Objective: Evaluate average days orders are delivered ahead of or behind the estimated delivery date by state.
SELECT 
    c.customer_state,
    ROUND(AVG(ROUND(DATEDIFF(day, o.order_delivered_customer_date, o.order_estimated_delivery_date), 2 )), 2) AS avg_days_ahead_of_estimate
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c 
	ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_days_ahead_of_estimate ASC;

-- Logistics Analysis 03: Freight Cost and Share by Customer State
-- Objective: Analyze average product price, freight value, and freight ratio relative to product price across states.
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(i.price), 2) AS avg_product_price,
    ROUND(AVG(i.freight_value), 2) AS avg_freight_value,
    ROUND(AVG(i.freight_value) / NULLIF(AVG(i.price), 0) * 100, 2) AS freight_to_price_ratio_pct
FROM olist_orders_dataset o
INNER JOIN olist_order_items_dataset i 
	ON o.order_id = i.order_id
INNER JOIN olist_customers_dataset c 
	ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY avg_freight_value DESC;