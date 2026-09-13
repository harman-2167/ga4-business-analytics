
## DATA QUALITY CHECKS

SELECT
  'Daily event volume' AS check_name,
  event_date,
  COUNT(*) AS event_count,
  COUNT(DISTINCT user_pseudo_id) AS unique_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201231'
GROUP BY event_date
ORDER BY event_date;


-- Check 2: Purchase events missing a transaction ID or revenue
SELECT
  'Invalid purchase records' AS check_name,
  COUNT(*) AS invalid_purchase_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201231'
  AND event_name = 'purchase'
  AND (
    ecommerce.transaction_id IS NULL
    OR ecommerce.transaction_id = ''
    OR ecommerce.purchase_revenue IS NULL
    OR ecommerce.purchase_revenue <= 0
  );


-- Check 3: Duplicate transaction IDs
SELECT
  'Duplicate transaction IDs' AS check_name,
  ecommerce.transaction_id,
  COUNT(*) AS purchase_event_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201231'
  AND event_name = 'purchase'
  AND ecommerce.transaction_id IS NOT NULL
  AND ecommerce.transaction_id != ''
  AND LOWER(ecommerce.transaction_id) NOT IN ('(not set)', 'not set')
GROUP BY ecommerce.transaction_id
HAVING COUNT(*) > 1
ORDER BY purchase_event_count DESC;


-- Check 4: Purchase revenue summary
SELECT
  'Revenue summary' AS check_name,
  COUNT(*) AS purchase_events,
  COUNT(DISTINCT ecommerce.transaction_id) AS unique_transactions,
  ROUND(SUM(ecommerce.purchase_revenue), 2) AS total_revenue,
  ROUND(AVG(ecommerce.purchase_revenue), 2) AS average_order_value
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201231'
  AND event_name = 'purchase';