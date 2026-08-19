
### DATA CLEANING

-------------------- 1. NULL / MISSING VALUE CHECK ---------------------

SELECT 
    COUNT(*) AS total_events,
    COUNTIF(user_pseudo_id IS NULL) AS missing_user_id,
    COUNTIF(event_name IS NULL) AS missing_event_name,
    COUNTIF(event_timestamp IS NULL) AS missing_event_timestamp
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`; 

-------------------- 2. DUPLICATE VALUE CHECK ------------------------

SELECT 
    user_pseudo_id,
    event_name,
    event_timestamp,
    COUNT(*) AS event_count
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY 
user_pseudo_id,
event_name,
event_timestamp
HAVING COUNT(*) > 1
ORDER BY event_count
DESC;

--------------------- 3. EVENT NAME VALIDATION ---------------------

SELECT 
    event_name,
    COUNT(*) AS event_count
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name 
ORDER BY event_count
DESC;

--------------------- 4. REVENUE VALIDATION ------------------------

SELECT 
    COUNT(*) AS total_revenue,
    COUNTIF(ecommerce.purchase_revenue < 0) AS negative_revenue,
    COUNTIF(ecommerce.purchase_revenue = 0) AS zero_revenue,
    MIN(ecommerce.purchase_revenue) AS minimum_revenue,
    MAX(ecommerce.purchase_revenue) AS maximum_revenue
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE   ecommerce.purchase_revenue IS NOT NULL;

-------------------- 5. PRODUCT VALIDATION -----------------------

SELECT 
    COUNT(*) AS total_items,
    COUNTIF(item.item_name IS NULL) AS missing_product_name,
    COUNTIF(item.price IS NULL) AS missing_price,
    COUNTIF(item.quantity IS NULL) AS missing_quantity,
    COUNTIF(item.price < 0) AS negative_price,
    COUNTIF(item.quantity <= 0) AS invalid_quantity
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item;

-------------------- 6. INVESTIGATION INVALID QUANTITIES -------------------

SELECT 
    item.item_name,
    item.quantity,
    item.price,
    COUNT(*) AS occurrences
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE item.quantity <=0
GROUP BY  
    item.item_name,
    item.quantity,
    item.price
ORDER BY
    occurrences DESC;

-------------------- 7. FINAL EVENT DATA QUALITY VALIDATION ---------------------

SELECT 
    COUNT(*) AS total_event,
    COUNTIF(event_name IS NULL) AS null_event_name,
    COUNTIF(user_pseudo_id IS NULL) AS null_user_id,
    COUNTIF(event_timestamp IS NULL) AS null_event_timestamp,
    COUNTIF(ecommerce.purchase_revenue < 0) AS negative_revenue
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

----------------------- 8. INVESTIGATION MISSING PRICE --------------------

SELECT 
    event_name,
    COUNT(*) AS total_items,
    COUNTIF(item.price IS NULL) AS missing_price,
    COUNTIF(item.quantity IS NULL) AS missing_quantity
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS item
GROUP BY
    event_name
ORDER BY
    missing_price 
DESC;

-------------------- 9. PURCHASE DATA QUALITY CHECK --------------------


SELECT
    COUNT(*) AS total_purchase_items,
    COUNTIF(item.price IS NULL) AS missing_price,
    COUNTIF(item.quantity IS NULL) AS missing_quantity,
    COUNTIF(item.price IS NOT NULL AND item.quantity IS NOT NULL) AS valid_items
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS item
WHERE
    event_name = 'purchase';

-------------------- 10. FINAL ITEM DATA QUALITY VALIDATION --------------------
 
SELECT
    COUNT(*) AS total_items,
    COUNTIF(item.item_name IS NULL) AS missing_product_name,
    COUNTIF(item.price IS NULL) AS missing_price,
    COUNTIF(item.quantity IS NULL) AS missing_quantity,
    COUNTIF(item.price < 0) AS negative_price,
    COUNTIF(item.quantity <= 0) AS invalid_quantity
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS item;