
### BUSINESS ANALYTICS

------------------------- 1. OVERALL BUSINESS PERFORMANCE ----------------------

SELECT
    COUNT(DISTINCT user_pseudo_id) AS total_users,
    COUNTIF(event_name = 'session_start') AS total_sessions,
    COUNTIF(event_name = 'purchase') AS total_orders,
    SUM(
        CASE
            WHEN event_name = 'purchase'
            THEN ecommerce.purchase_revenue
            ELSE 0
        END
    ) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------------- 2. AVERAGE ORDER VALUE ----------------------

SELECT
    SAFE_DIVIDE(
        SUM(ecommerce.purchase_revenue),
        COUNT(DISTINCT ecommerce.transaction_id)
    ) AS average_order_value

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
  AND ecommerce.transaction_id IS NOT NULL;