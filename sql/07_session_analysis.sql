
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
    COUNTIF(event_name = 'session_start') AS total_session,
    COUNT(*) / COUNTIF(event_name = 'session_start') AS avg_events_per_session
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--------------------- 5. SESSION BY DEVICE ---------------------------

SELECT 
    device.category AS device,
    COUNT(*) AS total_sessions
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start'
GROUP BY device
ORDER BY total_sessions DESC;

