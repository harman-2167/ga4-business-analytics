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

------------------ FULL FUNNEL ANALYSIS ------------------

WITH funnel AS (
    SELECT
        COUNT(DISTINCT CASE
            WHEN event_name = 'view_item'
            THEN user_pseudo_id END) AS view_users,

        COUNT(DISTINCT CASE
            WHEN event_name = 'add_to_cart'
            THEN user_pseudo_id END) AS cart_users,

        COUNT(DISTINCT CASE
            WHEN event_name = 'begin_checkout'
            THEN user_pseudo_id END) AS checkout_users,

        COUNT(DISTINCT CASE
            WHEN event_name = 'purchase'
            THEN user_pseudo_id END) AS purchase_users
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)

SELECT
    view_users,
    cart_users,
    checkout_users,
    purchase_users,

    ROUND(SAFE_DIVIDE(cart_users, view_users) * 100, 2)
        AS view_to_cart_rate,

    ROUND(SAFE_DIVIDE(checkout_users, cart_users) * 100, 2)
        AS cart_to_checkout_rate,

    ROUND(SAFE_DIVIDE(purchase_users, checkout_users) * 100, 2)
        AS checkout_to_purchase_rate,

    ROUND(SAFE_DIVIDE(purchase_users, view_users) * 100, 2)
        AS overall_purchase_rate

FROM funnel;

-------------------TOP PRODUCT BY REVENUE----------------------

SELECT
    item.item_name AS product_name,
    SUM(item.price_in_usd * item.quantity) AS total_revenue,
    SUM(item.quantity) AS total_quantity_sold  
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
    SUM(item.price_in_usd * item.quantity) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
WHERE event_name = 'purchase'   
GROUP BY product_name
ORDER BY total_quantity_sold
DESC
LIMIT 20;

------------------ REVENUE PER UNIT ------------------

SELECT
    item.item_name AS product_name,

    SUM(
        CASE
            WHEN event_name = 'purchase'
            THEN item.quantity
            ELSE 0
        END
    ) AS units_sold,

    SUM(
        CASE
            WHEN event_name = 'purchase'
            THEN item.price_in_usd * item.quantity
            ELSE 0
        END
    ) AS total_revenue,

    ROUND(
        SAFE_DIVIDE(
            SUM(
                CASE
                    WHEN event_name = 'purchase'
                    THEN item.price_in_usd * item.quantity
                    ELSE 0
                END
            ),
            SUM(
                CASE
                    WHEN event_name = 'purchase'
                    THEN item.quantity
                    ELSE 0
                END
            )
        ),
        2
    ) AS revenue_per_unit

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item

WHERE event_name = 'purchase'

GROUP BY product_name

HAVING units_sold > 0

ORDER BY revenue_per_unit DESC

LIMIT 20;

------------------Customer Behavior Analysis----------------------

-- New vs Returning User Approximation
-- Users with first_visit event are classified as new.
-- Users without first_visit event are treated as returning
-- within the available dataset.

WITH user_activity AS (
    SELECT
        user_pseudo_id,
        COUNTIF(event_name = 'first_visit') AS first_visit_events
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    GROUP BY user_pseudo_id
)

SELECT
    COUNTIF(first_visit_events > 0) AS new_users,
    COUNTIF(first_visit_events = 0) AS returning_users
FROM user_activity;

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

------------------ CUSTOMER REVENUE SEGMENTS ------------------

WITH customer_revenue AS (
    SELECT
        user_pseudo_id,
        SUM(
            CASE
                WHEN event_name = 'purchase'
                THEN ecommerce.purchase_revenue_in_usd
                ELSE 0
            END
        ) AS total_revenue
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    GROUP BY user_pseudo_id
)

SELECT
    CASE
        WHEN total_revenue >= 500 THEN 'High Value'
        WHEN total_revenue >= 100 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,

    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS revenue

FROM customer_revenue

WHERE total_revenue > 0

GROUP BY customer_segment

ORDER BY revenue DESC;

------------------ REVENUE BY USER ACQUISITION SOURCE ------------------

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

------------------ TRAFFIC SOURCE PERFORMANCE ------------------

SELECT
    traffic_source.source AS source,
    COUNT(DISTINCT user_pseudo_id) AS users,
    COUNTIF(event_name = 'purchase') AS purchases,

    ROUND(
        SAFE_DIVIDE(
            COUNTIF(event_name = 'purchase'),
            COUNT(DISTINCT user_pseudo_id)
        ) * 100,
        2
    ) AS purchase_rate

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
