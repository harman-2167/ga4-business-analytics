select 
    count(distinct user_pseudo_id) as total_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;