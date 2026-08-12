# Olist E-Commerce Analytics: From Raw Data to Insights

Hello! This is a hands-on project where I aimed to simulate the full end-to-end workflow of a real-world data analyst. I used Olist's public e-commerce dataset to practice building an automated Data Extraction, Transformation, and Loading (ETL) pipeline in Python, modeling data in SQL Server, and designing an interactive dashboard in Power BI.

The main goal was to answer real business questions: **Where is the operation losing money? Why are customers dissatisfied?**

---

## What I Built

### 1. Data Engineering & Cleaning
Before creating any visuals, I had to clean and organize the raw data:
* **Data Cleaning:** Removed duplicates to prevent double-counting revenue and systematically handled missing values.
* **Feature Engineering:** Built essential business metrics, such as `delay_days`, `is_delayed`, and `seller_dispatch_days` (time taken by the seller to hand over the product to the carrier).
* **Automated Data Loading:** Connected Python to SQL Server using `SQLAlchemy`, uploading data in batches to optimize system memory usage.

### 2. Interactive Dashboard
Created a report structured around three key business areas:
1. **Financial:** Revenue, average order value (AOV), and freight cost impact.
2. **Logistics:** On-time vs. delayed delivery rates and regional shipping bottlenecks.
3. **CX (Customer Experience):** Analyzing how delivery delays impact review scores.

---

## Key Findings & Business Insights

* **Financial Impact:** Freight accounts for **16.57%** of total company revenue ($2.25M out of $13.59M), signaling an opportunity to renegotiate carrier contracts.
* **Logistics Bottleneck:** While the overall delay rate is 6.45%, late deliveries suffer an average delay of **10.5 days past the estimated delivery date**. The states facing the highest delay rates are **BA, RJ, and ES**.
* **Customer Impact:** The data confirms a strong correlation between delivery delays and 1-star / 2-star reviews.

---

## Learnings & Next Steps
Building this project helped me realize that **data analytics is not just about creating pretty charts, but about solving real business problems**.

**Areas I want to improve in future iterations:**
* Write stored procedures inside SQL Server to automate data refreshes.
* Implement unit testing within the Python pipeline.
