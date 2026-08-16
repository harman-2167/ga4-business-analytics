
### PRODUCT ANALYSIS

----------------------- 1. PRODUCT WISE PERFORMANCE -----------------------

SELECT 
    item.item_name AS product_name,
    COUNT(DISTINCT user_pseudo_id) AS view_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
WHERE event_name = 'view_item'
GROUP BY product_name
ORDER BY view_users 
DESC;

------------------------ 2. PRODUCT ADD TO CART ---------------------------

SELECT 
    item.item_name AS product_name,
    COUNT(DISTINCT user_pseudo_id) AS cart_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST (items) AS item
WHERE event_name = 'add_to_cart'
GROUP BY product_name
ORDER BY cart_users
DESC;

----------------------- 3. PRODUCT PURCHASE --------------------------

SELECT 
    item.item_name AS product_name,
    COUNT(DISTINCT user_pseudo_id) AS purchasing_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
WHERE event_name = 'purchase'
GROUP BY product_name
ORDER BY purchasing_users
DESC;

----------------------- 4. PRODUCT CONVERSION RATE ----------------------

WITH product_users AS (
SELECT 
    item.item_name AS product_name,
    COUNT(DISTINCT CASE WHEN 
    event_name = 'view_item'
    THEN user_pseudo_id 
    END) AS view_users,

    COUNT(DISTINCT CASE
    WHEN event_name = 'purchase'
    THEN user_pseudo_id
    END) AS purchasing_users

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
GROUP BY product_name
)
SELECT
    product_name,
    view_users,
    purchasing_users,

ROUND(purchasing_users*100 / NULLIF(view_users ,0),2) AS purchasing_rate
FROM product_users
ORDER BY purchasing_rate 
DESC;

------------------------- 5. TOP PRODUCT BY REVENUE ----------------------

SELECT
    item.item_name AS product_name,
    SUM(ecommerce.purchase_revenue) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
WHERE event_name = 'purchase'
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;