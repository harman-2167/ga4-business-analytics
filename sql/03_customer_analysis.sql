
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

--------------------------3. One-Time vs Repeat Customers----------------------

SELECT
    user_pseudo_id,
    COUNT(*) AS purchase_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY user_pseudo_id
ORDER BY purchase_count DESC;

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