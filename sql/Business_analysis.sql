
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