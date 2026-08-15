
### CUSTOMER ANALYSIS

-------------------------- 1. PURCHASING USERS------------------------

SELECT
    COUNT(DISTINCT user_pseudo_id) AS purchasing_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase';

------------------------- 2. NON PURCHASING USERS---------------------

SELECT 
    COUNT(DISTINCT user_pseudo_id) AS total_users,

    COUNT(DISTINCT CASE 
        WHEN event_name = 'purchase' 
        THEN user_pseudo_id 
    END) AS purchasing_users,

    COUNT(DISTINCT user_pseudo_id)
    -
    COUNT(DISTINCT CASE 
        WHEN event_name = 'purchase' 
        THEN user_pseudo_id 
    END) AS non_purchasing_users

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------------------- 3. Purchase Count Per Customer ---------------------------

SELECT
    user_pseudo_id,
    COUNT(*) AS purchase_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY user_pseudo_id
ORDER BY purchase_count DESC;

--------------------------- 4. One-Time vs Repeat Customers ---------------------------

SELECT
    CASE
        WHEN purchase_count = 1 THEN 'One-Time Customer'
        WHEN purchase_count > 1 THEN 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        user_pseudo_id,
        COUNT(*) AS purchase_count
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name = 'purchase'
    GROUP BY user_pseudo_id
)
GROUP BY customer_type
ORDER BY number_of_customers DESC;

---------------------------4. Purchase Frequency Distribution----------------

SELECT
    purchase_count,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        user_pseudo_id,
        COUNT(*) AS purchase_count
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name = 'purchase'
    GROUP BY user_pseudo_id
)
GROUP BY purchase_count
ORDER BY purchase_count;

------------------------- 6. AVERAGE PURCHASE PER CUSTOMER -------------------

SELECT 
    AVG(purchase_count) AS average_purchase_per_customer
FROM(
    SELECT 
        user_pseudo_id,
        COUNT(*) AS purchase_count
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name = 'purchase'
    GROUP BY user_pseudo_id
);

-------------------------- 7. TOTAL REVENUE BY CUSTOMER ---------------------

SELECT 
    user_pseudo_id,
    SUM( ecommerce.purchase_revenue) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY user_pseudo_id
ORDER BY total_revenue
DESC;

-------------------------- 8. AVERAGE REVENUE PER CUSTOMER -------------------

SELECT 
    avg(total_revenue) AS average_revenue_per_customer
FROM (
    SELECT user_pseudo_id,
    SUM(ecommerce.purchase_revenue) AS total_revenue
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name = 'purchase'
    GROUP BY user_pseudo_id
);

------------------------- 9. AVERAGE ORDER VALUE -------------------

SELECT 
    avg(ecommerce.purchase_revenue) AS  average_order_value
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name = 'purchase';

------------------------- 10. TOP 10 CUSTOMER BY REVENUE------------------

SELECT 
    user_pseudo_id,
    SUM(ecommerce.purchase_revenue) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY user_pseudo_id
ORDER BY total_revenue DESC
LIMIT 10;
