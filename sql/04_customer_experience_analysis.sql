-----------------------------
-- Customer Experience Query
-----------------------------

-- Customer Experience Analysis 01: Review Score Distribution
-- Objective: Analyze overall customer satisfaction by calculating review counts, total share percentage, and average rating across score levels.
select 
	review_score,
	COUNT(review_id) AS total_reviews,
	ROUND(COUNT(review_id) * 100.0 / NULLIF(SUM(COUNT(review_id)) OVER(), 0), 2) AS review_share_pct
from olist_order_reviews_dataset
group by review_score
order by review_score DESC;

-- Customer Experience Analysis 03: Review Scores by Product Category
-- Objective: Identify top and bottom product categories based on average customer review score and review volume.
select 
	p.product_category_name,
	COUNT(DISTINCT r.review_id) AS total_reviews,
	ROUND(AVG(ROUND(r.review_score, 2)), 2) AS avg_review_score
from olist_order_items_dataset i
inner join olist_products_dataset p on i.product_id = p.product_id
inner join olist_order_reviews_dataset r on i.order_id = r.order_id
where p.product_category_name is not null
group by p.product_category_name
having COUNT(DISTINCT r.review_id) >= 50
order by avg_review_score DESC;

-- Customer Experience Analysis 04: Customer Response Time Metrics
-- Objective: Measure feedback processing speed by calculating average days between review creation and response answer date.
select 
	ROUND(AVG(ROUND(DATEDIFF(day, review_creation_date, review_answer_timestamp), 2)), 2) AS avg_response_time_days,
	COUNT(review_id) AS total_answered_reviews
from olist_order_reviews_dataset
where review_answer_timestamp is not null;