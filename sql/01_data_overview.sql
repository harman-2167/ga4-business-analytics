
---------------Dataset Verification------------------

SELECT *
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
LIMIT 10;

--------------Total Events---------------

SELECT 
    COUNT(*) AS total_event
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------Total Users----------------

SELECT 
    COUNT(DISTINCT user_pseudo_id) AS total_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------Total Days-----------------

SELECT 
    COUNT(DISTINCT event_date) AS total_days
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------First Date & Last Date-------------

SELECT 
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_date,
    MAX(PARSE_DATE('%Y%m%d',event_date)) AS last_date
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------Total Session-----------------

SELECT
  COUNT(DISTINCT CONCAT(
    user_pseudo_id,
    '-',
    CAST((
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS STRING)
  )) AS total_sessions
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

---------------Total Purchase----------------

SELECT 
    COUNT(*) AS total_purchase
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase';

---------------Total Page View----------------

SELECT 
    COUNT(*) AS total_page_view
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'page_view';

---------------Total New Users-----------------

SELECT
  COUNT(DISTINCT user_pseudo_id) AS total_new_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'first_visit';

---------------Total Returning users---------------

SELECT
  COUNT(DISTINCT user_pseudo_id) AS returning_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE user_pseudo_id NOT IN (
  SELECT DISTINCT user_pseudo_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE event_name = 'first_visit'
);

---------------Top 10 Event Types---------------

SELECT event_name,
    COUNT(*) AS total_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name
ORDER BY total_events
DESC
LIMIT 10;

---------------Event Distribution---------------

SELECT event_name,
    COUNT(*) AS total_events,
    ROUND(COUNT(*)*100.0/ SUM(COUNT(*))OVER (),2) AS percentage
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name
ORDER BY total_events
DESC;

--------------Average event per user-------------

SELECT
    ROUND(COUNT(*)/COUNT(DISTINCT user_pseudo_id),2) AS avg_event_per_user
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

--------------Average event per day--------------

SELECT 
    ROUND(COUNT(*)/COUNT(DISTINCT event_date),2) AS avg_event_per_date
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

--------------Dataset Size Summary------------------

SELECT 
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_pseudo_id) AS total_users,
    COUNT(DISTINCT event_date) AS total_days
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;