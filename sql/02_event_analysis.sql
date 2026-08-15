
### EVENT ANALYSIS

--------------------------- 1. EVENT FREQUENCY ---------------------------

SELECT
    event_name,
    COUNT(*) AS total_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name
ORDER BY total_events DESC;

--------------------------- 2. EVENT DISTRIBUTION ---------------------------

SELECT
    event_name,
    COUNT(*) AS total_events,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name
ORDER BY total_events DESC;

--------------------------- 3. UNIQUE USERS PER EVENT ---------------------------

SELECT
    event_name,
    COUNT(DISTINCT user_pseudo_id) AS unique_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name
ORDER BY unique_users DESC;

--------------------------- 4. AVERAGE EVENTS PER USER ---------------------------

SELECT
    ROUND(
        COUNT(*) * 1.0 / COUNT(DISTINCT user_pseudo_id),
        2
    ) AS avg_events_per_user
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------------------- 5. AVERAGE EVENTS PER DAY ---------------------------

SELECT
    ROUND(
        COUNT(*) * 1.0 / COUNT(DISTINCT event_date),
        2
    ) AS avg_events_per_day
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------------------- 6. DAILY EVENT TREND ---------------------------

SELECT
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    COUNT(*) AS total_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_date
ORDER BY event_date;