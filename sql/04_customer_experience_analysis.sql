-----------------------------
-- Customer Experience Query
-----------------------------

-- Customer Experience Analysis 01: Review Score Distribution
-- Objective: Analyze overall customer satisfaction by calculating review counts, total share percentage, and average rating across score levels.
SELECT 
	review_score,
	COUNT(review_id) AS total_reviews,
	ROUND(COUNT(review_id) * 100.0 / NULLIF(SUM(COUNT(review_id)) OVER(), 0), 2) AS review_share_pct
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score DESC;

-- Customer Experience Analysis 02: Review Scores by Product Category
-- Objective: Identify top and bottom product categories based on average customer review score and review volume.
SELECT
	p.product_category_name,
	COUNT(DISTINCT r.review_id) AS total_reviews,
	ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM olist_order_items_dataset i
INNER JOIN olist_products_dataset p ON i.product_id = p.product_id
INNER JOIN olist_order_reviews_dataset r ON i.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(DISTINCT r.review_id) >= 50
ORDER BY avg_review_score DESC;

-- Customer Experience Analysis 03: Customer Response Time Metrics
-- Objective: Measure feedback processing speed by calculating average days between review creation and response answer date.
SELECT
	ROUND(AVG(DATEDIFF(day, review_creation_date, review_answer_timestamp)), 2) AS avg_response_time_days,
	COUNT(review_id) AS total_answered_reviews
FROM olist_order_reviews_dataset
WHERE review_answer_timestamp IS NOT NULL;
