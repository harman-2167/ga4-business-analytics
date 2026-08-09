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
