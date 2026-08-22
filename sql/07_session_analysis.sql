
### SESSION ANALYSIS 

---------------------- 1. TOTAL SESSION ---------------------

SELECT 
    COUNT(*) AS total_session
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start';

---------------------- 2. SESSION BY DATE ----------------------

SELECT 
    event_date,
    COUNT(*) AS total_session
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start'
GROUP BY event_date
ORDER BY event_date;

--------------------- 3. AVERAGE SESSION PER USER ---------------------

SELECT 
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT user_pseudo_id) AS total_users,
    COUNT(*) / COUNT(DISTINCT user_pseudo_id) AS avg_sessions_per_user
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start';

--------------------- 4. AVERAGE EVENT PER SESSION ----------------------

SELECT 
    COUNT(*) AS total_events,
    COUNTIF(event_name = 'session_start') AS total_sessions,
    SAFE_DIVIDE(
        COUNT(*),
        COUNTIF(event_name = 'session_start')
    ) AS avg_events_per_session
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------------- 5. SESSION BY DEVICE ---------------------------

SELECT 
    device.category AS device,
    COUNT(*) AS total_sessions
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start'
GROUP BY device
ORDER BY total_sessions DESC;

--------------------- 6. SESSION BY TRAFFIC SOURCE ---------------------

SELECT 
    traffic_source.source AS  traffic_source,
    COUNT(*) AS total_sessions
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start'
GROUP BY traffic_source.source
ORDER BY total_sessions
DESC;

--------------------- 7. SESSION BY COUNTRY -----------------------

SELECT 
    geo.country AS country,
    COUNT(*) AS total_sessions
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start'
GROUP BY country
ORDER BY total_sessions
DESC;

--------------------- 8. SESSION CONVERSION TO PURCHASE -------------------

WITH sessions AS (
    SELECT 
        user_pseudo_id,

        (
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS session_id,

        MAX(
            CASE 
                WHEN event_name = 'purchase' THEN 1
                ELSE 0
            END
        ) AS purchased

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

    GROUP BY 
        user_pseudo_id,
        session_id
)

SELECT 
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchase_sessions,
    SAFE_DIVIDE(
        SUM(purchased),
        COUNT(*)
    ) * 100 AS session_conversion_rate

FROM sessions;

--------------------- 9. SESSION COUNT VALIDATION ---------------------

SELECT
    COUNT(*) AS session_start_events,
    COUNT(DISTINCT CONCAT(
        user_pseudo_id,
        '-',
        CAST((
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS STRING)
    )) AS unique_sessions
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start';
