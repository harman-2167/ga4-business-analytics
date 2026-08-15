
### FUNNEL ANALYSIS

---------------------- 1. FUNNEL USERS BY STAGE ----------------------

SELECT 
    event_name,
    COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name IN (
    'view_item',
    'add_to_cart',
    'begin_checkout',
    'purchase'
)
GROUP BY event_name
ORDER BY users 
DESC;

---------------------- 2. FUNNEL CONVERSION RATE ------------------------

WITH funnel AS (
    SELECT 
        COUNT(DISTINCT CASE WHEN event_name = 'view_item'
        THEN user_pseudo_id END ) AS product_viewers,

        COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart'
        THEN user_pseudo_id END ) AS cart_users,
        
        COUNT(DISTINCT CASE WHEN event_name = 'begin_checkout'
        THEN user_pseudo_id END ) AS checkout_users,

        COUNT(DISTINCT CASE WHEN event_name = 'purchase'
        THEN user_pseudo_id END ) AS purchasing_users

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)

SELECT 
    product_viewers,
    cart_users,
    checkout_users,
    purchasing_users,

    ROUND(cart_users *100 / product_viewers ,2)
        AS view_to_cart_rate,

    ROUND(checkout_users * 100.0 / cart_users, 2)
        AS cart_to_checkout_rate,

    ROUND(purchasing_users * 100.0 / checkout_users, 2)
        AS checkout_to_purchase_rate

FROM funnel;