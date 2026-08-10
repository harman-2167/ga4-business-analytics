--------------CUSTOMER PURCHASING FUNNEL ANALYSIS------------------

SELECT event_name,
    COUNT(*) AS total_count
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name IN ('view_item', 'add_to_cart','begin_checkout','purchase')
GROUP BY event_name
ORDER BY total_count
DESC;

----------------ADD TO CART CONVERSION RATE-----------------

SELECT 
ROUND(COUNT(DISTINCT CASE 
        WHEN event_name = 'add_to_cart'
        THEN user_pseudo_id
        END) * 100.0
        /
        COUNT(DISTINCT CASE
        WHEN event_name = 'view_item'
        THEN user_pseudo_id
        END),
        2
    ) AS add_to_cart_rate
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

----------------CHECKOUT CONVERSION RATE-----------------

SELECT 
ROUND(COUNT(DISTINCT CASE
        WHEN event_name ='begin_checkout'
        THEN user_pseudo_id
        END) *100.0
        /
        COUNT(DISTINCT CASE
        WHEN event_name ='add_to_cart'
        THEN user_pseudo_id
        END),2) AS checkout_conversion_rate
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

---------------PURCHASE CONVERSION RATE-----------------

SELECT 
ROUND(COUNT(DISTINCT CASE 
    WHEN event_name ='purchase'
    THEN user_pseudo_id
    END) *100.0
    /
    COUNT(DISTINCT CASE
    WHEN event_name ='begin_checkout'
    THEN user_pseudo_id
    END),2) AS purchase_conversion_rate
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

---------------OVERALL PURCHASE CONVERSION RATE-----------------

SELECT 
ROUND(COUNT(DISTINCT CASE 
    WHEN event_name ='purchase'
    THEN user_pseudo_id
    END) *100.0
    /
    COUNT(DISTINCT CASE
    WHEN event_name ='view_item'
    THEN user_pseudo_id
    END),2) AS overall_purchase_conversion_rate
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

------------------FUNNEL DROP OFF ANALYSIS-------------------

SELECT
    COUNT(DISTINCT CASE
        WHEN event_name = 'view_item'
        THEN user_pseudo_id
    END) AS view_users,

    COUNT(DISTINCT CASE
        WHEN event_name = 'add_to_cart'
        THEN user_pseudo_id
    END) AS add_to_cart_users,

    COUNT(DISTINCT CASE
        WHEN event_name = 'view_item'
        THEN user_pseudo_id
    END)
    -
    COUNT(DISTINCT CASE
        WHEN event_name = 'add_to_cart'
        THEN user_pseudo_id
    END) AS users_dropped,
    ROUND((
    COUNT(DISTINCT CASE
        WHEN event_name = 'view_item'
        THEN user_pseudo_id
        END)
            -
        COUNT(DISTINCT CASE
            WHEN event_name = 'add_to_cart'
            THEN user_pseudo_id
        END)
        ) * 100.0
        /
        COUNT(DISTINCT CASE
            WHEN event_name = 'view_item'
            THEN user_pseudo_id
        END),
        2
    ) AS drop_off_rate

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

-------------------TOP PRODUCT BY REVENUE----------------------

SELECT
    item.item_name AS product_name,
    SUM(item.price_in_usd * item.quantity) AS total_revenue,
    SUM(item.quantity* item.quantity) AS total_quantity_sold
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS item
WHERE event_name = 'purchase'
GROUP BY product_name
ORDER BY total_revenue 
DESC
LIMIT 20;

--------------------TOP PRODUCT BY QUANTITY SOLD----------------------

SELECT 
    item.item_name AS product_name,
    SUM(item.quantity) AS total_quantity_sold,
    SUM(item.price_in_usd) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
WHERE event_name = 'purchase'   
GROUP BY product_name
ORDER BY total_quantity_sold
DESC
LIMIT 20;

------------------REVENUE PER UNIT----------------------

SELECT 
    item.item_name AS product_name,
    COUNTIF(event_name ='view_item') AS product_views,
    COUNTIF(event_name ='purchase') AS purchase_events,
    SUM(
        CASE 
            WHEN event_name = 'purchase'
            THEN item.quantity
            ELSE 0
        END
    ) AS units_sold,
     SAFE_DIVIDE(
        COUNTIF(event_name = 'purchase'),
        COUNTIF(event_name = 'view_item')
    ) * 100 AS view_to_purchase_rate
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item

WHERE event_name IN ('view_item', 'purchase')

GROUP BY product_name

ORDER BY product_views DESC
LIMIT 20;

------------------Customer Behavior Analysis----------------------

-----------------New vs Returning Users------------------

SELECT
    COUNT (DISTINCT CASE
    WHEN event_name = 'first_visit' THEN user_pseudo_id
  END) AS new_users,

  COUNT(DISTINCT CASE
    WHEN event_name != 'first_visit' THEN user_pseudo_id
  END) AS active_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

------------------PURCHASE FREQUENCY----------------------

SELECT
  user_pseudo_id,
  COUNTIF(event_name = 'purchase') AS purchase_count,
  SUM(
    CASE
      WHEN event_name = 'purchase'
      THEN ecommerce.purchase_revenue_in_usd
      ELSE 0
    END
  ) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY user_pseudo_id
HAVING purchase_count > 0
ORDER BY total_revenue DESC;

-------------------Customer Revenue Segments----------------------

SELECT
  user_pseudo_id,
  COUNTIF(event_name = 'purchase') AS purchases,
  SUM(
    CASE
      WHEN event_name = 'purchase'
      THEN ecommerce.purchase_revenue_in_usd
      ELSE 0
    END
  ) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY user_pseudo_id
HAVING total_revenue > 0
ORDER BY total_revenue DESC
LIMIT 20;

--------------------Traffic Source Analysis----------------------

------------------Revenue by Traffic Source----------------------
SELECT
  traffic_source.source AS source,
  traffic_source.medium AS medium,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNTIF(event_name = 'purchase') AS purchases,
  SUM(
    CASE
      WHEN event_name = 'purchase'
      THEN ecommerce.purchase_revenue_in_usd
      ELSE 0
    END
  ) AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY source, medium
ORDER BY revenue DESC;

------------------Traffic Source Performance----------------------

SELECT
  traffic_source.source AS source,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNTIF(event_name = 'purchase') AS purchases,
  SAFE_DIVIDE(
    COUNTIF(event_name = 'purchase'),
    COUNT(DISTINCT user_pseudo_id)
  ) * 100 AS purchase_rate
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY source
ORDER BY purchase_rate DESC;

-------------------Revenue Analysis----------------------

------------------Total Revenue----------------------\

SELECT
  SUM(ecommerce.purchase_revenue_in_usd) AS total_revenue,
  COUNT(DISTINCT user_pseudo_id) AS purchasing_users,
  COUNTIF(event_name = 'purchase') AS total_purchases
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase';

--------------------Revenue by Date----------------------

SELECT
  PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
  SUM(ecommerce.purchase_revenue_in_usd) AS revenue,
  COUNTIF(event_name = 'purchase') AS purchases
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY purchase_date
ORDER BY purchase_date;

--------------------Monthly Revenue----------------------

SELECT
  FORMAT_DATE(
    '%Y-%m',
    PARSE_DATE('%Y%m%d', event_date)
  ) AS month,
  SUM(ecommerce.purchase_revenue_in_usd) AS revenue,
  COUNTIF(event_name = 'purchase') AS purchases
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY month
ORDER BY month;

-------------------Average Order Value----------------------

SELECT
  SAFE_DIVIDE(
    SUM(ecommerce.purchase_revenue_in_usd),
    COUNTIF(event_name = 'purchase')
  ) AS average_order_value
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase';
