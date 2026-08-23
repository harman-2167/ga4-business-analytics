
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

--------------------- 3. SESSION CONVERSION RATE ----------------------

WITH session_data AS (
    SELECT
        user_pseudo_id,
        (
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS session_id,
        event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),

sessions AS (
    SELECT DISTINCT
        user_pseudo_id,
        session_id
    FROM session_data
    WHERE event_name = 'session_start'
      AND session_id IS NOT NULL
),

purchase_sessions AS (
    SELECT DISTINCT
        user_pseudo_id,
        session_id
    FROM session_data
    WHERE event_name = 'purchase'
      AND session_id IS NOT NULL
)

SELECT
    COUNT(*) AS total_sessions,
    COUNT(p.user_pseudo_id) AS purchase_sessions,

    SAFE_DIVIDE(
        COUNT(p.user_pseudo_id),
        COUNT(*)
    ) * 100 AS session_conversion_rate

FROM sessions s

LEFT JOIN purchase_sessions p
    ON s.user_pseudo_id = p.user_pseudo_id
    AND s.session_id = p.session_id;

--------------------- 4. REVENUE PER SESSION ----------------------

WITH session_data AS (
    SELECT
        user_pseudo_id,
        (
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS session_id,
        event_name,
        ecommerce.purchase_revenue
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),

sessions AS (
    SELECT DISTINCT
        user_pseudo_id,
        session_id
    FROM session_data
    WHERE event_name = 'session_start'
      AND session_id IS NOT NULL
),

revenue AS (
    SELECT
        SUM(purchase_revenue) AS total_revenue
    FROM session_data
    WHERE event_name = 'purchase'
)

SELECT
    r.total_revenue,
    COUNT(s.session_id) AS total_sessions,

    SAFE_DIVIDE(
        r.total_revenue,
        COUNT(s.session_id)
    ) AS revenue_per_session

FROM sessions s
CROSS JOIN revenue r
GROUP BY r.total_revenue;

--------------------- 5. MONTHLY BUSINESS PERFORMANCE ----------------------

SELECT
    FORMAT_DATE(
        '%Y-%m',
        PARSE_DATE('%Y%m%d', event_date)
    ) AS month,

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

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY month
ORDER BY month;

--------------------- 6. MONTHLY REVENUE GROWTH ----------------------

WITH monthly_revenue AS (
    SELECT
        FORMAT_DATE(
            '%Y-%m',
            PARSE_DATE('%Y%m%d', event_date)
        ) AS month,

        SUM(
            CASE
                WHEN event_name = 'purchase'
                THEN ecommerce.purchase_revenue
                ELSE 0
            END
        ) AS revenue

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

    GROUP BY month
)

SELECT
    month,
    revenue,

    LAG(revenue) OVER (
        ORDER BY month
    ) AS previous_month_revenue,

    SAFE_DIVIDE(
        revenue - LAG(revenue) OVER (ORDER BY month),
        LAG(revenue) OVER (ORDER BY month)
    ) * 100 AS revenue_growth_rate

FROM monthly_revenue
ORDER BY month;

--------------------- 7. MONTHLY ORDER GROWTH ----------------------

WITH monthly_orders AS (
    SELECT
        FORMAT_DATE(
            '%Y-%m',
            PARSE_DATE('%Y%m%d', event_date)
        ) AS month,

        COUNTIF(event_name = 'purchase') AS total_orders

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

    GROUP BY month
)

SELECT
    month,
    total_orders,

    LAG(total_orders) OVER (
        ORDER BY month
    ) AS previous_month_orders,

    SAFE_DIVIDE(
        total_orders - LAG(total_orders) OVER (ORDER BY month),
        LAG(total_orders) OVER (ORDER BY month)
    ) * 100 AS order_growth_rate

FROM monthly_orders
ORDER BY month;

--------------------- 8. MONTHLY CONVERSION RATE ----------------------

WITH monthly_sessions AS (
    SELECT
        FORMAT_DATE(
            '%Y-%m',
            PARSE_DATE('%Y%m%d', event_date)
        ) AS month,

        user_pseudo_id,

        (
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS session_id,

        event_name

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),

sessions AS (
    SELECT DISTINCT
        month,
        user_pseudo_id,
        session_id
    FROM monthly_sessions
    WHERE event_name = 'session_start'
      AND session_id IS NOT NULL
),

purchase_sessions AS (
    SELECT DISTINCT
        month,
        user_pseudo_id,
        session_id
    FROM monthly_sessions
    WHERE event_name = 'purchase'
      AND session_id IS NOT NULL
)

SELECT
    s.month,

    COUNT(*) AS total_sessions,

    COUNT(p.session_id) AS purchase_sessions,

    SAFE_DIVIDE(
        COUNT(p.session_id),
        COUNT(*)
    ) * 100 AS conversion_rate

FROM sessions s

LEFT JOIN purchase_sessions p
    ON s.user_pseudo_id = p.user_pseudo_id
    AND s.session_id = p.session_id
    AND s.month = p.month

GROUP BY s.month
ORDER BY s.month;

--------------------- 9. REVENUE BY DEVICE ----------------------

SELECT
    device.category AS device,

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

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY device

ORDER BY total_revenue DESC;

--------------------- 10. REVENUE BY TRAFFIC SOURCE ----------------------

SELECT
    traffic_source.source AS traffic_source,

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

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY traffic_source.source

ORDER BY total_revenue DESC;

--------------------- 11. TOP PRODUCT PERFORMANCE ----------------------

SELECT
    item.item_name AS product,

    COUNT(DISTINCT user_pseudo_id) AS total_users,

    COUNTIF(event_name = 'view_item') AS product_views,

    COUNTIF(event_name = 'add_to_cart') AS add_to_cart_events,

    COUNTIF(event_name = 'purchase') AS purchase_events,

    SUM(
        CASE
            WHEN event_name = 'purchase'
            THEN item.price_in_usd * item.quantity
            ELSE 0
        END
    ) AS product_revenue

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item

GROUP BY product

ORDER BY product_revenue DESC
LIMIT 20;

--------------------- 12. TOP COUNTRY PERFORMANCE ----------------------

SELECT
    geo.country AS country,

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

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY country

ORDER BY total_revenue DESC
LIMIT 20;