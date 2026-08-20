
### REVENUE ANALYSIS 

------------------- 1. TOTAL REVENUE ----------------------

SELECT 
    SUM(
        SELECT SUM(item.price * item.quantity)
        FROM UNNEST(items) AS item
    )AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase';

----------------------- 2. MONTHLY REVENUE ------------------------

SELECT 
    FORMAT_DATE('%Y-%m', PARSE_DATE ('%Y%m%d, event_date')) AS month,
    SUM(
        SELECT SUM(item.price * item.quantity)
        FROM UNNEST(items) AS item
    )AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY month
ORDER BY month;

-------------------- 3. AVERAGE ORDER VALUE --------------------

SELECT 
  SUM(
    (SELECT SUM(item.price * item.quantity)
     FROM UNNEST(items) AS item)
  )/COUNT(DISTINCT ecommerce.transaction_id) AS average_order_value

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
  AND ecommerce.transaction_id IS NOT NULL;


-------------------- 4. REVENUE BY TRAFFIC SOURCE --------------------

SELECT 
  traffic_source.source AS traffic_source,
  SUM(
    (SELECT SUM(item.price * item.quantity)
     FROM UNNEST(items) AS item)
  ) AS revenue

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY traffic_source
ORDER BY revenue DESC;

-------------------- 5. REVENUE BY PRODUCT ----------------------

SELECT 
    item.item_name AS product_name,
    SUM(item.price * item.quantity) AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
WHERE event_name = 'purchase'
GROUP BY product_name
ORDER BY revenue DESC;


------------------- 6. MONTHLY REVENUE GROWTH ---------------------

WITH monthly_revenue AS (
  SELECT
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', event_date)) AS month,
    SUM(
      (SELECT SUM(item.price * item.quantity)
       FROM UNNEST(items) AS item)
    ) AS revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE event_name = 'purchase'
  GROUP BY month )

SELECT
  month,
  revenue,
  ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY month))
    / LAG(revenue) OVER (ORDER BY month) * 100,
    2
  ) AS revenue_growth_percent
FROM monthly_revenue
ORDER BY month;