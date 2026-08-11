from google.cloud import bigquery
import pandas as pd

#BigQuery Client
client = bigquery.Client()

# GA4 dataset
TABLE = "bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*"


# --------------------------------------------------
# 1. TOTAL REVENUE & PURCHASE KPIs
# --------------------------------------------------

query = f"""
SELECT
    SUM(ecommerce.purchase_revenue_in_usd) AS total_revenue,
    COUNT(DISTINCT user_pseudo_id) AS purchasing_users,
    COUNTIF(event_name = 'purchase') AS total_purchases
FROM `{TABLE}`
WHERE event_name = 'purchase'
"""
kpi_df = client.query(query).to_dataframe()

print("\n========== GA4 BUSINESS KPIs ==========")
print(kpi_df)

# ----------------------------------------------------------
# 2. MONTHLY REVENUE TREND
# ----------------------------------------------------------

query = f"""
SELECT 
    FORMAT_DATE(
        '%Y-%m',
        PARSE_DATE('%Y%m%d', event_date)
        ) AS month,
    SUM(ecommerce.purchase_revenue_in_usd) AS monthly_revenue,
    COUNTIF(event_name = 'purchase') AS monthly_purchases
FROM `{TABLE}`
WHERE event_name = 'purchase'
GROUP BY month
ORDER BY month
"""

monthly_revenue_df = client.query(query).to_dataframe()

print("\n=========== MONTHLY REVENUE TREND ===========")
print(monthly_revenue_df)

# ----------------------------------------------------------
# 3. TOP PRODUCTS BY REVENUE
# ----------------------------------------------------------

query = f"""
SELECT
    item.item_name AS product_name,
    SUM(item.price_in_usd * item.quantity) AS revenue,
    SUM(item.quantity) AS units_sold
FROM `{TABLE}`,
    UNNEST(items) AS item
WHERE event_name = 'purchase'
GROUP BY product_name
ORDER BY revenue
DESC
LIMIT 20
    """
product_df = client.query(query).to_dataframe()

print("\n============= TOP PRODUCTS BY REVENUE =============")
print(product_df)

# ------------------------------------------------------------
# 4. ACQUISITION SOURCE PERFORMANCE
# ------------------------------------------------------------

query = f"""
SELECT 
    traffic_source.source AS source,
    COUNT(DISTINCT user_pseudo_id) AS users,
    COUNTIF(event_name = 'purchase') AS purchases,
    SUM(
        CASE
        WHEN event_name = 'purchase'
        THEN ecommerce.purchase_revenue_in_usd
        ELSE 0
        END
    ) AS revenue
FROM `{TABLE}`
GROUP BY source 
ORDER BY revenue
DESC """

source_df = client.query(query).to_dataframe()

print("\n============= ACQUISITION SOURCE PERFORMANCE =============")
print(source_df)